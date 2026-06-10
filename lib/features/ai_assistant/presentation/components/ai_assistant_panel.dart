import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsd/features/ai_assistant/domain/ai_service.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_message.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_stream_events.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_key_setup_view.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_messages_body.dart';
import 'package:vsd/features/ai_assistant/presentation/components/current_tool_display.dart';
import 'package:vsd/features/ai_assistant/presentation/components/input_box.dart';
import 'package:vsd/features/ai_assistant/presentation/utils/replay_stream_controller.dart';
import 'package:vsd/features/mcp/vsd_mcp_server.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';

const _kApiKeyPref = 'anthropic_api_key';

class AiAssistantPanel extends StatefulWidget {
  const AiAssistantPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  State<AiAssistantPanel> createState() => _AiAssistantPanelState();
}

class _AiAssistantPanelState extends State<AiAssistantPanel> {
  // ------- Services -------
  VsdMcpServer? _mcpServer;
  AiService? _aiService;
  bool _servicesReady = false;
  String? _initError;

  // ------- Key setup -------
  bool _keySetupMode = false;
  String? _keySetupErrorHint;
  String _storedKey = '';

  // ------- Conversation state -------
  final List<AiMessage> _messages = [];
  bool _isSending = false;
  String? _toolActivity;
  StreamSubscription<AiStreamEvent>? _activeSub;
  ReplayStreamController? _currentStreamController;

  // ------- Lifecycle -------

  @override
  void initState() {
    super.initState();
    unawaited(_initServices());
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_kApiKeyPref) ?? '';
    _storedKey = key;

    if (key.trim().isEmpty) {
      if (mounted) {
        setState(() => _keySetupMode = true);
      }
      return;
    }

    try {
      final mcpServer = await VsdMcpServer.create();
      final aiService = AiService(mcpServer, key);

      if (mounted) {
        setState(() {
          _mcpServer = mcpServer;
          _aiService = aiService;
          _servicesReady = true;
          _keySetupMode = false;
          _initError = null;
        });
      } else {
        aiService.dispose();
        unawaited(mcpServer.dispose());
      }
    } on StateError {
      if (mounted) {
        setState(() {
          _keySetupMode = true;
          _keySetupErrorHint = 'Could not initialize with this key. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _initError = e.toString());
      }
    }
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kApiKeyPref, key);
    _storedKey = key;

    _aiService?.dispose();
    unawaited(_mcpServer?.dispose());

    if (mounted) {
      setState(() {
        _keySetupMode = false;
        _keySetupErrorHint = null;
        _servicesReady = false;
        _initError = null;
        _aiService = null;
        _mcpServer = null;
      });
      unawaited(_initServices());
    }
  }

  @override
  void dispose() {
    unawaited(_activeSub?.cancel());
    _aiService?.dispose();
    unawaited(_mcpServer?.dispose());
    super.dispose();
  }

  // ------- Send / receive -------

  Future<void> _sendMessage(String text) async {
    if (!_servicesReady || _isSending) {
      return;
    }

    final history = List<AiMessage>.from(_messages);
    _currentStreamController = ReplayStreamController();

    setState(() {
      _messages.add(AiMessage(text: text, isUser: true));
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

    _activeSub = _aiService!
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
                  _messages[_messages.length - 1] = last.copyWith(text: last.text + text);
                });
              case AiToolActivity(:final message):
                setState(() => _toolActivity = message);
              case AiDone():
                _finishStreaming();
              case AiError(:final message, :final isAuthError):
                if (isAuthError) {
                  _finishStreaming(errorText: message);
                  if (mounted) {
                    setState(() {
                      _keySetupMode = true;
                      _keySetupErrorHint = 'Invalid or unauthorized key.';
                      _servicesReady = false;
                    });
                  }
                } else {
                  _finishStreaming(errorText: message);
                }
            }
          },
          onError: (Object e) {
            if (mounted) {
              _finishStreaming(errorText: e.toString());
            }
          },
          onDone: () {
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
        _messages[_messages.length - 1] = last.copyWith(text: finalText, isStreaming: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          _header(),
          const Divider(height: 1),
          Expanded(
            child: _keySetupMode
                ? AiKeySetupView(
                    onSave: _saveApiKey,
                    initialKey: _storedKey,
                    errorHint: _keySetupErrorHint,
                  )
                : AiMessagesBody(
                    messages: _messages,
                    ready: _servicesReady,
                    initializationError: _initError,
                  ),
          ),
          if (!_keySetupMode) ...[
            if (_toolActivity != null) CurrentToolDisplay(toolActivity: _toolActivity),
            InputBox(onSend: _sendMessage, ready: _servicesReady, isSending: _isSending),
          ],
        ],
      ),
    );
  }

  Widget _header() {
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
            ToolIconButton(icon: FontAwesomeIcons.stop, tooltip: 'Stop', onTap: _stopStreaming),
          ToolIconButton(
            icon: FontAwesomeIcons.key,
            tooltip: 'Set API key',
            onTap: () => setState(() {
              _keySetupMode = true;
              _keySetupErrorHint = null;
            }),
          ),
          ToolIconButton(icon: FontAwesomeIcons.xmark, tooltip: 'Close', onTap: widget.onClose),
        ],
      ),
    );
  }
}
