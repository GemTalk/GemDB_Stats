/// A single message in the AI assistant conversation.
class AiMessage {
  AiMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    this.stream,
  });

  /// The message content. May grow incrementally while [isStreaming] is true.
  final String text;

  /// Whether this message was sent by the user (`true`) or the assistant (`false`).
  final bool isUser;

  /// Whether the assistant is still streaming this message.
  final bool isStreaming;

  /// Stable stream reference used by the Streamdown widget.
  /// Created once — never recreated on rebuild — so Streamdown doesn't reset.
  final Stream<String>? stream;

  AiMessage copyWith({String? text, bool? isStreaming, Stream<String>? stream}) {
    return AiMessage(
      text: text ?? this.text,
      isUser: isUser,
      isStreaming: isStreaming ?? this.isStreaming,
      stream: stream ?? this.stream,
    );
  }
}
