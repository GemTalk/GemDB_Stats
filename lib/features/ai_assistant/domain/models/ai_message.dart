/// A single message in the AI assistant conversation.
class AiMessage {
  AiMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    this.isIntermediate = false,
    this.stream,
    this.toolActivity,
  });

  /// Creates a tool call history entry.
  AiMessage.toolCall(String activity)
    : text = activity,
      isUser = false,
      isStreaming = false,
      isIntermediate = false,
      stream = null,
      toolActivity = activity;

  /// The message content. May grow incrementally while [isStreaming] is true.
  final String text;

  /// Whether this message was sent by the user (`true`) or the assistant (`false`).
  final bool isUser;

  /// Whether the assistant is still streaming this message.
  final bool isStreaming;

  /// True for assistant text segments that were finalized mid-turn before a tool call.
  /// The copy button is suppressed on these since more content follows.
  final bool isIntermediate;

  /// Stable stream reference used by the Streamdown widget.
  /// Created once — never recreated on rebuild — so Streamdown doesn't reset.
  final Stream<String>? stream;

  /// Non-null when this entry represents a tool call activity (not a chat message).
  final String? toolActivity;

  AiMessage copyWith({String? text, bool? isStreaming, bool? isIntermediate, Stream<String>? stream}) {
    return AiMessage(
      text: text ?? this.text,
      isUser: isUser,
      isStreaming: isStreaming ?? this.isStreaming,
      isIntermediate: isIntermediate ?? this.isIntermediate,
      stream: stream ?? this.stream,
    );
  }
}
