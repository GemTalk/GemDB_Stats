import 'package:flutter/widgets.dart';

/// Stands in for [AiAssistantPanel] on the web, where the assistant is left
/// out: it runs an MCP server over `dart:io`, and a browser would need a CORS
/// opt-in and would hold the API key. Never shown, since the web build hides
/// the chat toggle.
class AiAssistantPanel extends StatelessWidget {
  const AiAssistantPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
