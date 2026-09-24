import 'package:flutter/material.dart';

class AiKeySetupView extends StatefulWidget {
  const AiKeySetupView({
    required this.onSave,
    this.hasExistingKey = false,
    this.onCancel,
    this.errorHint,
    super.key,
  });

  final void Function(String key) onSave;
  final bool hasExistingKey;
  final VoidCallback? onCancel;
  final String? errorHint;

  @override
  State<AiKeySetupView> createState() => _AiKeySetupViewState();
}

class _AiKeySetupViewState extends State<AiKeySetupView> {
  static final _placeholder = '•' * 108;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showingPlaceholder = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    if (widget.hasExistingKey) {
      _showPlaceholder();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showPlaceholder() {
    _showingPlaceholder = true;
    _controller.text = _placeholder;
  }

  /// Focusing the field clears the stand-in so whatever is typed or pasted
  /// replaces it; leaving the field empty brings the stand-in back.
  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      if (_showingPlaceholder) {
        setState(() {
          _showingPlaceholder = false;
          _controller.clear();
        });
      }
    } else if (widget.hasExistingKey && _controller.text.isEmpty) {
      setState(_showPlaceholder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Enter your Anthropic API key\nto use the AI assistant.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return TextField(
                controller: _controller,
                focusNode: _focusNode,
                obscureText: widget.hasExistingKey,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'sk-ant-...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.black38),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                ),
              );
            },
          ),
          if (widget.errorHint != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.errorHint!,
              style: const TextStyle(fontSize: 12, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final canSave = !_showingPlaceholder && _controller.text.trim().isNotEmpty;
              return FilledButton(
                onPressed: canSave ? () => widget.onSave(_controller.text.trim()) : null,
                style: FilledButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 13),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Save'),
              );
            },
          ),
          if (widget.onCancel != null) ...[
            const SizedBox(height: 4),
            TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 13),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ],
      ),
    );
  }
}
