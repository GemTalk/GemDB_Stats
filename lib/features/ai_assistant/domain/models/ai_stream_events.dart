/// Base class for events emitted by [AiService.chat].
sealed class AiStreamEvent {
  const AiStreamEvent();
}

/// A text delta streamed token-by-token from the LLM.
class AiTextDelta extends AiStreamEvent {
  const AiTextDelta(this.text);
  final String text;
}

/// Indicates that the LLM is currently calling an MCP tool.
class AiToolActivity extends AiStreamEvent {
  const AiToolActivity(this.message);
  final String message;
}

/// Signals successful completion of the assistant turn.
class AiDone extends AiStreamEvent {
  const AiDone();
}

/// Signals an error (network, auth, etc.).
class AiError extends AiStreamEvent {
  const AiError(this.message, {this.isAuthError = false});
  final String message;
  final bool isAuthError;
}
