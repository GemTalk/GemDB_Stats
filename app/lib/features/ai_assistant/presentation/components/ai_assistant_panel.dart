import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsd/features/ai_assistant/domain/ai_backend.dart';
import 'package:vsd/features/ai_assistant/domain/ai_service.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_config.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_message.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_stream_events.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_messages_body.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_setup_view.dart';
import 'package:vsd/features/ai_assistant/presentation/components/input_box.dart';
import 'package:vsd/features/ai_assistant/presentation/utils/replay_stream_controller.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';
import 'package:vsd_mcp/vsd_mcp.dart';

const _kApiKeyPref = 'anthropic_api_key';
const _kConfigPref = 'aws_sso_config';
const _kAuthModePref = 'ai_auth_mode';

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
  AwsSsoSession? _session;
  bool _servicesReady = false;
  String? _initError;

  // ------- Setup -------
  AiAuthMode _mode = AiAuthMode.bedrock;
  AwsSsoConfig? _config;
  bool _hasStoredKey = false;
  bool _setupMode = false;
  bool _signInBusy = false;
  AwsSsoDeviceAuthorization? _pendingAuth;
  String? _setupErrorHint;

  // ------- Conversation state -------
  final List<AiMessage> _messages = [];
  bool _isSending = false;
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

    _config = _readConfig(prefs);
    final storedKey = prefs.getString(_kApiKeyPref)?.trim() ?? '';
    _hasStoredKey = storedKey.isNotEmpty;

    // With no explicit choice recorded, follow whichever provider is already
    // configured, so existing API-key users are not pushed into AWS sign-in.
    final storedMode = prefs.getString(_kAuthModePref);
    _mode = storedMode != null
        ? AiAuthMode.fromName(storedMode)
        : (_hasStoredKey ? AiAuthMode.anthropicApiKey : AiAuthMode.bedrock);

    final backend = await _restoreBackend(storedKey);
    if (backend == null) {
      if (mounted) {
        setState(() => _setupMode = true);
      }
      return;
    }

    await _startServices(backend);
  }

  /// Rebuilds the configured backend from stored settings, or null when the
  /// user still has to set something up or sign in.
  Future<AiBackend?> _restoreBackend(String storedKey) async {
    switch (_mode) {
      case AiAuthMode.anthropicApiKey:
        if (storedKey.isEmpty) {
          return null;
        }
        return AnthropicApiKeyBackend(apiKey: storedKey);

      case AiAuthMode.bedrock:
        final config = _config;
        if (config == null || !config.isComplete) {
          return null;
        }
        final session = AwsSsoSession(config: config);
        _session?.dispose();
        _session = session;
        // A stored access token survives restarts, so this usually skips
        // sign-in entirely.
        if (!await session.hasValidToken()) {
          return null;
        }
        return BedrockAiBackend(config: config, session: session);
    }
  }

  Future<void> _startServices(AiBackend backend) async {
    try {
      final mcpServer = await VsdMcpServer.create();
      final aiService = AiService(mcpServer, backend);

      if (mounted) {
        setState(() {
          _mcpServer = mcpServer;
          _aiService = aiService;
          _servicesReady = true;
          _setupMode = false;
          _setupErrorHint = null;
          _initError = null;
        });
      } else {
        aiService.dispose();
        unawaited(mcpServer.dispose());
      }
    } catch (e) {
      // Ownership only transfers once AiService is built, so release it here.
      backend.dispose();
      if (mounted) {
        setState(() {
          _initError = e.toString();
          // Surfaced twice: when this runs straight after setup the setup view
          // is still on screen, and it shows this hint instead of _initError.
          _setupErrorHint = e.toString();
        });
      }
    }
  }

  void _teardownServices() {
    // Disposing AiService also disposes the backend it owns.
    _aiService?.dispose();
    unawaited(_mcpServer?.dispose());
    _aiService = null;
    _mcpServer = null;
    _servicesReady = false;
  }

  // ------- Provider selection -------

  Future<void> _changeMode(AiAuthMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAuthModePref, mode.name);
    if (mounted) {
      setState(() {
        _mode = mode;
        _setupErrorHint = null;
        _pendingAuth = null;
        _signInBusy = false;
      });
    }
  }

  Future<void> _saveApiKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) {
      // The form disables Save while empty, so this is only a backstop.
      if (mounted) {
        setState(() {
          _setupMode = true;
          _setupErrorHint = 'Could not initialize with this key. Please try again.';
        });
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kApiKeyPref, trimmed);
    await prefs.setString(_kAuthModePref, AiAuthMode.anthropicApiKey.name);
    _hasStoredKey = true;
    _mode = AiAuthMode.anthropicApiKey;

    _teardownServices();
    await _startServices(AnthropicApiKeyBackend(apiKey: trimmed));
  }

  /// Saves [config], then runs the device-authorization flow end to end.
  Future<void> _signIn(AwsSsoConfig config) async {
    setState(() {
      _signInBusy = true;
      _setupErrorHint = null;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kConfigPref, jsonEncode(config.toJson()));
    await prefs.setString(_kAuthModePref, AiAuthMode.bedrock.name);
    _config = config;
    _mode = AiAuthMode.bedrock;

    _teardownServices();
    _session?.dispose();
    final session = AwsSsoSession(config: config);
    _session = session;

    try {
      final auth = await session.beginLogin();
      if (!mounted) {
        return;
      }
      setState(() {
        _pendingAuth = auth;
        _signInBusy = false;
      });

      await _openVerificationUri(auth);
      await session.waitForApproval(auth);

      if (!mounted) {
        return;
      }
      setState(() => _pendingAuth = null);
      await _startServices(BedrockAiBackend(config: config, session: session));
    } catch (e) {
      if (mounted) {
        setState(() {
          _pendingAuth = null;
          _signInBusy = false;
          _setupErrorHint = e.toString();
        });
      }
    }
  }

  Future<void> _openVerificationUri(AwsSsoDeviceAuthorization auth) async {
    final target = auth.verificationUriComplete.isNotEmpty ? auth.verificationUriComplete : auth.verificationUri;
    final uri = Uri.tryParse(target);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  AwsSsoConfig? _readConfig(SharedPreferences prefs) {
    final raw = prefs.getString(_kConfigPref);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? AwsSsoConfig.fromJson(decoded) : null;
  }

  @override
  void dispose() {
    unawaited(_activeSub?.cancel());
    _aiService?.dispose();
    unawaited(_mcpServer?.dispose());
    _session?.dispose();
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
                final last = _messages.last;
                if (last.text.isNotEmpty) {
                  // Text was already streamed this iteration — finalize that segment,
                  // append the tool call, then start a fresh streaming bubble so the
                  // next iteration's text appears after the tool call in the history.
                  final oldController = _currentStreamController!;
                  _currentStreamController = ReplayStreamController();
                  unawaited(oldController.close());
                  setState(() {
                    _messages[_messages.length - 1] = last.copyWith(isStreaming: false, isIntermediate: true);
                    _messages.add(AiMessage.toolCall(message));
                    _messages.add(
                      AiMessage(
                        text: '',
                        isUser: false,
                        isStreaming: true,
                        stream: _currentStreamController!.stream,
                      ),
                    );
                  });
                } else {
                  setState(() {
                    _messages.insert(_messages.length - 1, AiMessage.toolCall(message));
                  });
                }
              case AiDone():
                _finishStreaming();
              case AiError(:final message, :final isAuthError):
                if (isAuthError) {
                  _finishStreaming(errorText: message);
                  if (mounted) {
                    setState(() {
                      _setupMode = true;
                      _setupErrorHint = message;
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
    final last = _messages.isNotEmpty && !_messages.last.isUser ? _messages.last : null;
    final hasPriorContent = _messages.length >= 2 && !_messages[_messages.length - 2].isUser;

    // The bubble renders from its stream, not from message.text, so closing
    // text (errors, fallbacks) must be pushed into the stream before it
    // closes or it will never be displayed.
    String? closingText;
    if (last != null) {
      if (errorText != null) {
        closingText = last.text.isEmpty ? '⚠ $errorText' : '\n\n⚠ $errorText';
      } else if (last.text.isEmpty && !hasPriorContent) {
        closingText = '(no response)';
      }
    }
    if (closingText != null) {
      _currentStreamController?.add(closingText);
    }
    unawaited(_currentStreamController?.close());
    _currentStreamController = null;

    setState(() {
      _isSending = false;
      if (last == null) {
        return;
      }
      if (last.text.isEmpty && closingText == null) {
        // Empty placeholder left after tool calls — remove it.
        _messages.removeLast();
      } else {
        _messages[_messages.length - 1] = last.copyWith(
          text: last.text + (closingText ?? ''),
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
          _header(),
          const Divider(height: 1),
          Expanded(
            child: _setupMode
                ? AiSetupView(
                    mode: _mode,
                    onModeChanged: (mode) => unawaited(_changeMode(mode)),
                    onSaveApiKey: (key) => unawaited(_saveApiKey(key)),
                    onSignIn: (config) => unawaited(_signIn(config)),
                    initialSsoConfig: _config,
                    hasExistingKey: _hasStoredKey,
                    pendingAuth: _pendingAuth,
                    busy: _signInBusy,
                    onOpenVerificationUri: _pendingAuth == null
                        ? null
                        : () => unawaited(_openVerificationUri(_pendingAuth!)),
                    onCancel: _servicesReady ? () => setState(() => _setupMode = false) : null,
                    errorHint: _setupErrorHint,
                  )
                : AiMessagesBody(
                    messages: _messages,
                    ready: _servicesReady,
                    initializationError: _initError,
                  ),
          ),
          if (!_setupMode) ...[
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
          if (_isSending) ToolIconButton(icon: FontAwesomeIcons.stop, tooltip: 'Stop', onTap: _stopStreaming),
          ToolIconButton(
            icon: FontAwesomeIcons.key,
            tooltip: 'AI provider settings',
            onTap: () => setState(() {
              _setupMode = true;
              _setupErrorHint = null;
            }),
          ),
          ToolIconButton(icon: FontAwesomeIcons.xmark, tooltip: 'Close', onTap: widget.onClose),
        ],
      ),
    );
  }
}
