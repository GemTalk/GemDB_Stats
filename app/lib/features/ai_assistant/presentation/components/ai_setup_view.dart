import 'package:flutter/material.dart';
import 'package:vsd/features/ai_assistant/domain/ai_backend.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_config.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_key_setup_view.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_sign_in_view.dart';

/// Lets the user choose a provider and configure it.
///
/// Both providers reach the same models; which one to use is usually dictated
/// by how the organisation pays for and governs Claude access, so neither is
/// presented as the default.
class AiSetupView extends StatelessWidget {
  const AiSetupView({
    required this.mode,
    required this.onModeChanged,
    required this.onSaveApiKey,
    required this.onSignIn,
    this.initialSsoConfig,
    this.hasExistingKey = false,
    this.pendingAuth,
    this.busy = false,
    this.onOpenVerificationUri,
    this.onCancel,
    this.errorHint,
    super.key,
  });

  final AiAuthMode mode;
  final ValueChanged<AiAuthMode> onModeChanged;
  final void Function(String key) onSaveApiKey;
  final void Function(AwsSsoConfig config) onSignIn;

  /// Previously saved AWS settings, if any.
  final AwsSsoConfig? initialSsoConfig;

  /// Whether an API key is already stored, so the field can stand in for it.
  final bool hasExistingKey;

  final AwsSsoDeviceAuthorization? pendingAuth;
  final bool busy;
  final VoidCallback? onOpenVerificationUri;
  final VoidCallback? onCancel;
  final String? errorHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hidden mid-approval: switching provider at that point would abandon
        // a sign-in the user is already completing in their browser.
        if (pendingAuth == null) _picker(),
        Expanded(
          child: mode == AiAuthMode.bedrock
              ? AiSignInView(
                  initialConfig: initialSsoConfig,
                  onSignIn: onSignIn,
                  pendingAuth: pendingAuth,
                  busy: busy,
                  onOpenVerificationUri: onOpenVerificationUri,
                  onCancel: onCancel,
                  errorHint: errorHint,
                )
              : AiKeySetupView(
                  onSave: onSaveApiKey,
                  hasExistingKey: hasExistingKey,
                  onCancel: onCancel,
                  errorHint: errorHint,
                ),
        ),
      ],
    );
  }

  Widget _picker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SegmentedButton<AiAuthMode>(
        segments: [
          for (final value in AiAuthMode.values) ButtonSegment<AiAuthMode>(value: value, label: Text(value.label)),
        ],
        selected: {mode},
        onSelectionChanged: (selection) => onModeChanged(selection.first),
        showSelectedIcon: false,
        style: const ButtonStyle(
          textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
