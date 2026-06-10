import 'package:flutter/material.dart';
import 'package:streamdown/streamdown.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_message.dart';
import 'package:vsd/features/ai_assistant/presentation/components/copy_button.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, required this.index, super.key});

  final AiMessage message;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (message.toolActivity != null) {
      return toolActivityDisplay();
    }

    final showTyping = !message.isUser && message.isStreaming && message.text.isEmpty;

    Widget content;
    if (message.isUser) {
      content = SelectableText(message.text, style: const TextStyle(fontSize: 13));
    } else if (showTyping) {
      content = const Text('…', style: TextStyle(fontSize: 18, color: Colors.black45));
    } else {
      content = Streamdown(
        key: ValueKey('msg_$index'),
        stream: message.stream!,
        selectable: true,
      );
    }

    final showCopyButton = !message.isUser && !message.isStreaming && !message.isIntermediate;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: message.isUser ? null : double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFFDCF5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: showCopyButton
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  content,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CopyButton(text: message.text),
                  ),
                ],
              )
            : content,
      ),
    );
  }

  Padding toolActivityDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        children: [
          const Icon(Icons.construction, size: 11, color: Colors.black38),
          const SizedBox(width: 4),
          Text(
            message.toolActivity!,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black45,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
