import 'package:flutter/material.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_config.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';

/// Collects the AWS SSO settings and runs the browser-approval step.
///
/// Purely presentational: the panel owns the sign-in flow and passes the
/// pending [AwsSsoDeviceAuthorization] back down once it has one.
class AiSignInView extends StatefulWidget {
  const AiSignInView({
    required this.initialConfig,
    required this.onSignIn,
    this.pendingAuth,
    this.busy = false,
    this.onOpenVerificationUri,
    this.onCancel,
    this.errorHint,
    super.key,
  });

  /// Previously saved settings, if any.
  final AwsSsoConfig? initialConfig;

  final void Function(AwsSsoConfig config) onSignIn;

  /// Set once the device authorization exists and we are awaiting approval.
  final AwsSsoDeviceAuthorization? pendingAuth;

  /// True while registering the device authorization.
  final bool busy;

  final VoidCallback? onOpenVerificationUri;
  final VoidCallback? onCancel;
  final String? errorHint;

  @override
  State<AiSignInView> createState() => _AiSignInViewState();
}

class _AiSignInViewState extends State<AiSignInView> {
  late final Map<String, TextEditingController> _controllers;

  static const _labels = {
    'startUrl': 'SSO start URL',
    'ssoRegion': 'SSO region',
    'accountId': 'AWS account ID',
    'roleName': 'Role name',
    'bedrockRegion': 'Bedrock region',
    'modelId': 'Model ID',
  };

  static const _hints = {
    'startUrl': 'https://my-org.awsapps.com/start/',
    'ssoRegion': 'eu-central-1',
    'accountId': '123456789012',
    'roleName': 'MyBedrockRole',
    'bedrockRegion': 'eu-central-1',
    'modelId': AwsSsoConfig.defaultModelId,
  };

  @override
  void initState() {
    super.initState();
    final config = widget.initialConfig;
    _controllers = {
      'startUrl': TextEditingController(text: config?.startUrl ?? ''),
      'ssoRegion': TextEditingController(text: config?.ssoRegion ?? ''),
      'accountId': TextEditingController(text: config?.accountId ?? ''),
      'roleName': TextEditingController(text: config?.roleName ?? ''),
      'bedrockRegion': TextEditingController(text: config?.bedrockRegion ?? ''),
      'modelId': TextEditingController(
        text: config?.modelId ?? AwsSsoConfig.defaultModelId,
      ),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  AwsSsoConfig get _config => AwsSsoConfig(
    startUrl: _controllers['startUrl']!.text.trim(),
    ssoRegion: _controllers['ssoRegion']!.text.trim(),
    accountId: _controllers['accountId']!.text.trim(),
    roleName: _controllers['roleName']!.text.trim(),
    bedrockRegion: _controllers['bedrockRegion']!.text.trim(),
    modelId: _controllers['modelId']!.text.trim(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: widget.pendingAuth != null ? _approvalPrompt() : _configForm(),
    );
  }

  // ------- Awaiting browser approval -------

  Widget _approvalPrompt() {
    final auth = widget.pendingAuth!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Approve the sign-in request in your browser,\nthen confirm this code matches.',
          style: TextStyle(fontSize: 13, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        SelectableText(
          auth.userCode,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
        const SizedBox(height: 16),
        if (widget.onOpenVerificationUri != null)
          TextButton(
            onPressed: widget.onOpenVerificationUri,
            style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 13)),
            child: const Text('Open the browser again'),
          ),
        if (widget.errorHint != null) _errorText(widget.errorHint!),
        if (widget.onCancel != null)
          TextButton(
            onPressed: widget.onCancel,
            style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 13)),
            child: const Text('Cancel'),
          ),
      ],
    );
  }

  // ------- Settings form -------

  Widget _configForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sign in with AWS to use the AI assistant.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          for (final key in _labels.keys) ...[
            _field(key),
            const SizedBox(height: 8),
          ],
          if (widget.errorHint != null) _errorText(widget.errorHint!),
          const SizedBox(height: 4),
          ListenableBuilder(
            // Rebuild as the user types so the button enables itself.
            listenable: Listenable.merge(_controllers.values.toList()),
            builder: (context, _) {
              final canSignIn = !widget.busy && _config.isComplete;
              return FilledButton(
                onPressed: canSignIn ? () => widget.onSignIn(_config) : null,
                style: FilledButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 13),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(widget.busy ? 'Starting sign-in…' : 'Sign in with AWS SSO'),
              );
            },
          ),
          if (widget.onCancel != null)
            TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 13)),
              child: const Text('Cancel'),
            ),
        ],
      ),
    );
  }

  Widget _field(String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_labels[key]!, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 2),
        TextField(
          controller: _controllers[key],
          autocorrect: false,
          enableSuggestions: false,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: _hints[key],
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            border: _border(Colors.black12),
            enabledBorder: _border(Colors.black12),
            focusedBorder: _border(Colors.black38),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(color: color),
  );

  Widget _errorText(String message) => Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 2),
    child: Text(
      message,
      style: const TextStyle(fontSize: 12, color: Colors.red),
      textAlign: TextAlign.center,
    ),
  );
}
