import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;
import 'package:mcp_dart/mcp_dart.dart' as mcp;
import 'package:vsd/features/ai_assistant/domain/models/ai_message.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_stream_events.dart';
import 'package:vsd_core/vsd_core.dart';
import 'package:vsd_mcp/vsd_mcp.dart';

/// Drives the agentic loop between the user, Claude, and the [VsdMcpServer].
///
/// ## Lifecycle
/// 1. Construct with a pre-initialized [VsdMcpServer] — throws [StateError]
///    if the API key is missing or unconfigured.
/// 2. Call [chat] for each user turn; subscribe to the returned stream.
/// 3. Call [dispose] when done.
class AiService {
  AiService(this._mcpServer, String apiKey) {
    if (apiKey.trim().isEmpty) {
      throw StateError('API key is empty.');
    }
    _client = anthropic.AnthropicClient(
      config: anthropic.AnthropicConfig(
        authProvider: anthropic.ApiKeyProvider(apiKey.trim()),
      ),
    );
  }

  final VsdMcpServer _mcpServer;
  late final anthropic.AnthropicClient _client;

  static const _model = 'claude-sonnet-4-6';
  static const _maxTokens = 4096;
  static const _maxIterations = 10;

  void dispose() {
    _client.close();
  }

  /// Sends [userMessage] to Claude and streams back [AiStreamEvent]s.
  ///
  /// Pass [history] (the visible message list, user + assistant pairs only)
  /// so Claude retains conversation context. The last 10 completed pairs are
  /// used; older messages are silently dropped.
  Stream<AiStreamEvent> chat(
    String userMessage,
    List<AiMessage> history,
  ) async* {
    try {
      // Fetch tool definitions from the MCP server once per turn.
      final toolsResult = await _mcpServer.listTools();
      final tools = toolsResult.tools.map(_mcpToolToAnthropic).toList();

      // Build the message list: history + new user message.
      final messages = <anthropic.InputMessage>[
        ..._historyToMessages(history),
        anthropic.InputMessage(
          role: anthropic.MessageRole.user,
          content: anthropic.MessageContent.text(userMessage),
        ),
      ];

      // Agentic loop — repeats when Claude uses tools.
      for (var iteration = 0; iteration < _maxIterations; iteration++) {
        final accumulator = anthropic.MessageStreamAccumulator();

        final stream = _client.messages.createStream(
          anthropic.MessageCreateRequest(
            model: _model,
            maxTokens: _maxTokens,
            system: anthropic.SystemPrompt.text(_buildSystemPrompt()),
            tools: tools,
            messages: messages,
          ),
        );

        // Stream text deltas to the UI in real time.
        await for (final event in stream) {
          accumulator.add(event);
          if (event is anthropic.ContentBlockDeltaEvent) {
            final delta = event.delta;
            if (delta is anthropic.TextDelta) {
              yield AiTextDelta(delta.text);
            }
          }
        }

        final message = accumulator.toMessage();

        // ── Natural end of turn ───────────────────────────────────────────────
        if (message.stopReason == anthropic.StopReason.endTurn) {
          yield const AiDone();
          return;
        }

        // ── Tool use ──────────────────────────────────────────────────────────
        if (message.stopReason == anthropic.StopReason.toolUse) {
          final toolUseBlocks = message.content.whereType<anthropic.ToolUseBlock>().toList();

          final toolResultBlocks = <anthropic.InputContentBlock>[];

          for (final block in toolUseBlocks) {
            yield AiToolActivity(_formatToolActivity(block.name));

            try {
              final result = await _mcpServer.callTool(block.name, block.input);
              final resultText = extractToolResultText(result);
              toolResultBlocks.add(
                anthropic.InputContentBlock.toolResultText(
                  toolUseId: block.id,
                  text: resultText,
                  isError: result.isError,
                ),
              );
            } catch (e) {
              toolResultBlocks.add(
                anthropic.InputContentBlock.toolResult(
                  toolUseId: block.id,
                  content: [anthropic.ToolResultContent.text('Error: $e')],
                  isError: true,
                ),
              );
            }
          }

          // Append the assistant's tool-use turn.
          messages.add(
            anthropic.InputMessage(
              role: anthropic.MessageRole.assistant,
              content: anthropic.MessageContent.blocks(
                message.content.map(_contentBlockToInput).toList(),
              ),
            ),
          );
          // Append the tool results as a user turn.
          messages.add(
            anthropic.InputMessage(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.blocks(toolResultBlocks),
            ),
          );

          continue; // next iteration
        }

        // Unexpected stop reason — surface the text and finish.
        yield const AiDone();
        return;
      }

      // Exceeded max iterations.
      yield const AiDone();
    } on anthropic.AuthenticationException {
      yield const AiError(
        'Invalid or unauthorized API key.',
        isAuthError: true,
      );
    } on anthropic.RateLimitException {
      yield const AiError(
        'Rate limit reached. Please wait a moment and try again.',
      );
    } catch (e) {
      yield AiError('Unexpected error: $e');
    }
  }

  // ------- Private helpers -------

  /// Converts an mcp_dart [mcp.Tool] to an Anthropic [anthropic.ToolDefinition].
  ///
  /// Uses [mcp.Tool.inputSchema.toJson] → [anthropic.InputSchema.fromJson] so
  /// the schemas are kept in sync without duplication.
  anthropic.ToolDefinition _mcpToolToAnthropic(mcp.Tool tool) {
    return anthropic.ToolDefinition.custom(
      anthropic.Tool(
        name: tool.name,
        description: tool.description,
        inputSchema: anthropic.InputSchema.fromJson(tool.inputSchema.toJson()),
      ),
    );
  }

  /// Converts a response [anthropic.ContentBlock] to an
  /// [anthropic.InputContentBlock] for multi-turn message reconstruction.
  anthropic.InputContentBlock _contentBlockToInput(
    anthropic.ContentBlock block,
  ) {
    return switch (block) {
      anthropic.TextBlock(:final text) => anthropic.InputContentBlock.text(text),
      anthropic.ToolUseBlock(:final id, :final name, :final input) => anthropic.InputContentBlock.toolUse(
        id: id,
        name: name,
        input: input,
      ),
      _ =>
        // Silently discard unknown blocks (thinking, citations, etc.).
        anthropic.InputContentBlock.text(''),
    };
  }

  /// Converts the visible [history] into Anthropic input messages.
  ///
  /// Only completed user+assistant pairs are included.
  /// At most 10 pairs (20 messages) are kept to limit token usage.
  List<anthropic.InputMessage> _historyToMessages(List<AiMessage> history) {
    // Remove tool-call entries and merge consecutive assistant segments so each
    // user turn maps to exactly one assistant entry for the Anthropic history.
    final merged = <AiMessage>[];
    for (final msg in history) {
      if (msg.toolActivity != null) {
        continue;
      }
      if (!msg.isUser && merged.isNotEmpty && !merged.last.isUser) {
        final prev = merged.last;
        merged[merged.length - 1] = prev.copyWith(text: '${prev.text}\n\n${msg.text}');
      } else {
        merged.add(msg);
      }
    }

    final pairs = <(AiMessage, AiMessage)>[];
    for (var i = 0; i + 1 < merged.length; i += 2) {
      final user = merged[i];
      final asst = merged[i + 1];
      if (user.isUser && !asst.isUser && asst.text.isNotEmpty) {
        pairs.add((user, asst));
      }
    }

    const maxPairs = 10;
    final capped = pairs.length > maxPairs ? pairs.sublist(pairs.length - maxPairs) : pairs;

    return capped
        .expand<anthropic.InputMessage>(
          (pair) => [
            anthropic.InputMessage(
              role: anthropic.MessageRole.user,
              content: anthropic.MessageContent.text(pair.$1.text),
            ),
            anthropic.InputMessage(
              role: anthropic.MessageRole.assistant,
              content: anthropic.MessageContent.text(pair.$2.text),
            ),
          ],
        )
        .toList();
  }

  /// Builds the system prompt, including a lightweight dataset overview
  /// so the LLM has immediate context before calling any tools.
  String _buildSystemPrompt() {
    final dm = DataManager();
    final buf = StringBuffer()
      ..writeln(
        'You are an analytics assistant for VSD (Virtual Statistics Display), '
        'a performance monitoring tool for GemStone Smalltalk processes. '
        'You help users understand process performance data loaded from statmon files.',
      );

    if (dm.allProcesses.isEmpty) {
      buf
        ..writeln()
        ..writeln(
          'No data is currently loaded. If the user asks questions about data, '
          'tell them to load a statmon file first using the file picker at the top of the app.',
        );
      return buf.toString();
    }

    buf
      ..writeln()
      ..writeln('## Currently Loaded Data')
      ..writeln('Process names: ${dm.processes.keys.join(', ')}')
      ..writeln('Total process instances: ${dm.allProcesses.length}')
      ..writeln(
        'Stat types: ${dm.statTypes.values.map((t) => t.name).toSet().join(', ')}',
      );

    if (dm.allProcesses.isNotEmpty) {
      final allTimes = dm.allProcesses.expand((p) => [p.startTime, p.endTime]).toList();
      final minT = allTimes.reduce((a, b) => a.isBefore(b) ? a : b);
      final maxT = allTimes.reduce((a, b) => a.isAfter(b) ? a : b);
      final dur = maxT.difference(minT);
      buf.writeln(
        'Time range: ${FileTime.format(minT)} → ${FileTime.format(maxT)} '
        '(${dur.inMinutes} min)',
      );
    }

    buf
      ..writeln()
      ..writeln('## Guidelines')
      ..writeln(
        '- Use the provided tools to query data before answering questions.',
      )
      ..writeln(
        '- Call list_processes first when you are unsure what data is available.',
      )
      ..writeln('- Always include units when presenting numeric values.')
      ..writeln(
        '- Be concise and analytical; highlight insights, not raw data dumps.',
      );

    return buf.toString();
  }

  /// Converts a snake_case tool name to a human-readable activity string.
  String _formatToolActivity(String toolName) {
    return switch (toolName) {
      VsdTools.listProcesses => 'Listing processes',
      VsdTools.getProcessDetails => 'Getting process details',
      VsdTools.getDatasetOverview => 'Getting dataset overview',
      VsdTools.getStatisticValues => 'Querying time-series data',
      VsdTools.getStatisticSummary => 'Computing statistics summary',
      VsdTools.compareProcesses => 'Comparing processes',
      VsdTools.findTopStatistics => 'Finding top statistics',
      _ => 'Querying data',
    };
  }
}
