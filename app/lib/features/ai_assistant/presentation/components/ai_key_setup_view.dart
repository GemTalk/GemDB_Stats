import 'package:flutter/material.dart';

class AiKeySetupView extends StatefulWidget {
  const AiKeySetupView({
    required this.onSave,
    this.initialKey = '',
    this.errorHint,
    super.key,
  });

  final void Function(String key) onSave;
  final String initialKey;
  final String? errorHint;

  @override
  State<AiKeySetupView> createState() => _AiKeySetupViewState();
}

class _AiKeySetupViewState extends State<AiKeySetupView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            'Enter your Anthropic API key to use the AI assistant.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return TextField(
                controller: _controller,
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
              final isEmpty = _controller.text.trim().isEmpty;
              return FilledButton(
                onPressed: isEmpty ? null : () => widget.onSave(_controller.text.trim()),
                style: FilledButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 13),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Save'),
              );
            },
          ),
        ],
      ),
    );
  }
}
