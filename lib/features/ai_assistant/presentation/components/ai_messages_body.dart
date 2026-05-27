import 'package:flutter/material.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/features/ai_assistant/domain/models/ai_message.dart';
import 'package:vsd/features/ai_assistant/presentation/components/message_bubble.dart';

class AiMessagesBody extends StatelessWidget {
  const AiMessagesBody({required this.messages, required this.ready, this.initializationError, super.key});

  final List<AiMessage> messages;
  final bool ready;
  final String? initializationError;

  @override
  Widget build(BuildContext context) {
    // Still initializing.
    if (!ready && initializationError == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 8),
            Text(
              'Initializing…',
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      );
    }

    // Init failed.
    if (initializationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            initializationError!,
            style: const TextStyle(fontSize: 12, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // No data loaded banner.
    if (DataManager().allProcesses.isEmpty && messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Open a .out file to start analyzing your data.',
            style: TextStyle(fontSize: 13, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'Ask a question about your data',
          style: TextStyle(fontSize: 13, color: Colors.black45),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) => MessageBubble(message: messages[index], index: index),
    );
  }
}
