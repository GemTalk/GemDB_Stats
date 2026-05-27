import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    required this.onSend,
    required this.ready,
    required this.isSending,
    super.key,
  });

  final void Function(String text) onSend;
  final bool ready;
  final bool isSending;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void _sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty || !widget.ready || widget.isSending) {
      return;
    }
    textController.clear();
    widget.onSend(text);
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Focus(
            onKeyEvent: (node, event) {
              // Shift+Enter inserts a newline; bare Enter sends.
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter &&
                  !HardwareKeyboard.instance.isShiftPressed) {
                _sendMessage();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              enabled: widget.ready && !widget.isSending,
              style: const TextStyle(fontSize: 13),
              maxLines: null,
              minLines: 3,
              decoration: InputDecoration(
                hintText: widget.ready ? 'Ask about your data…' : 'Initializing…',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
                isDense: true,
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black38),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black12),
                ),
              ),
              textInputAction: TextInputAction.newline,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: ToolIconButton(
              icon: FontAwesomeIcons.paperPlane,
              tooltip: 'Send',
              onTap: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
