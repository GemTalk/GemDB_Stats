import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vsd/features/ai_assistant/domain/ai_service.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_message.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_stream_events.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_messages_body.dart';
import 'package:vsd/features/ai_assistant/presentation/components/current_tool_display.dart';
import 'package:vsd/features/ai_assistant/presentation/components/input_box.dart';
import 'package:vsd/features/ai_assistant/presentation/utils/replay_stream_controller.dart';
import 'package:vsd/features/mcp/vsd_mcp_server.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';

class AiAssistantPanel extends StatefulWidget {
  const AiAssistantPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  State<AiAssistantPanel> createState() => _AiAssistantPanelState();
}

class _AiAssistantPanelState extends State<AiAssistantPanel> {
  // ------- Services-------
  late final VsdMcpServer _mcpServer;
  late final AiService _aiService;
  bool _servicesReady = false;
  String? _initError;

  // ------- Conversation state -------
  final List<AiMessage> _messages = [];
  bool _isSending = false;
  String? _toolActivity; // shown while a tool is running
  StreamSubscription<AiStreamEvent>? _activeSub;
  ReplayStreamController? _currentStreamController;

  // ------- Lifecycle -------

  @override
  void initState() {
    super.initState();
    unawaited(_initServices());
  }

  Future<void> _initServices() async {
    try {
      _mcpServer = await VsdMcpServer.create();

      _aiService = AiService(_mcpServer);

      if (mounted) {
        setState(() => _servicesReady = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _initError = e.toString());
      }
    }
  }

  @override
  void dispose() {
    unawaited(_activeSub?.cancel());
    _aiService.dispose();
    unawaited(_mcpServer.dispose());
    super.dispose();
  }

  // ------- Send / receive -------

  Future<void> _sendMessage(String text) async {
    if (!_servicesReady || _isSending) {
      return;
    }

    // Snapshot of completed history to pass as context.
    final history = List<AiMessage>.from(_messages);

    _currentStreamController = ReplayStreamController();

    setState(() {
      _messages.add(AiMessage(text: text, isUser: true));
      // Placeholder streaming message — stream stored once so Streamdown always receives the same object and never resets on rebuild.
      _messages.add(
        AiMessage(
          text: '',
          isUser: false,
          isStreaming: true,
          stream: _currentStreamController!.stream,
        ),
      );
      _isSending = true;
      _toolActivity = null;
    });

    _activeSub = _aiService
        .chat(text, history)
        .listen(
          (event) {
            if (!mounted) {
              return;
            }
            switch (event) {
              case AiTextDelta(:final text):
                _currentStreamController?.add(text);
                setState(() {
                  final last = _messages.last;
                  _messages[_messages.length - 1] = last.copyWith(
                    text: last.text + text,
                  );
                });
              case AiToolActivity(:final message):
                setState(() => _toolActivity = message);
              case AiDone():
                _finishStreaming();
              case AiError(:final message):
                _finishStreaming(errorText: message);
            }
          },
          onError: (Object e) {
            if (mounted) {
              _finishStreaming(errorText: e.toString());
            }
          },
          onDone: () {
            // Ensure we always clean up even if AiDone was not emitted.
            if (mounted && _isSending) {
              _finishStreaming();
            }
          },
        );
  }

  void _stopStreaming() {
    unawaited(_activeSub?.cancel());
    _activeSub = null;
    _finishStreaming();
  }

  void _finishStreaming({String? errorText}) {
    if (!mounted) {
      return;
    }
    unawaited(_currentStreamController?.close());
    _currentStreamController = null;
    setState(() {
      _isSending = false;
      _toolActivity = null;
      if (_messages.isNotEmpty && !_messages.last.isUser) {
        final last = _messages.last;
        final finalText = errorText != null
            ? (last.text.isEmpty ? '⚠ $errorText' : last.text)
            : (last.text.isEmpty ? '(no response)' : last.text);
        _messages[_messages.length - 1] = last.copyWith(
          text: finalText,
          isStreaming: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          header(),
          const Divider(height: 1),
          Expanded(
            child: AiMessagesBody(messages: _messages, ready: _servicesReady, initializationError: _initError),
          ),
          if (_toolActivity != null) CurrentToolDisplay(toolActivity: _toolActivity),
          InputBox(
            onSend: _sendMessage,
            ready: _servicesReady,
            isSending: _isSending,
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          const Text(
            'AI Assistant',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          if (_isSending)
            ToolIconButton(
              icon: FontAwesomeIcons.stop,
              tooltip: 'Stop',
              onTap: _stopStreaming,
            ),
          ToolIconButton(
            icon: FontAwesomeIcons.xmark,
            tooltip: 'Close',
            onTap: widget.onClose,
          ),
        ],
      ),
    );
  }
}
