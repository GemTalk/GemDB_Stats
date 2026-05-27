import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';
import 'package:vsd/presentation/ai_assistant/ai_message.dart';
import 'package:vsd/presentation/ai_assistant/input_box.dart';

class AiAssistantPanel extends StatefulWidget {
  const AiAssistantPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  State<AiAssistantPanel> createState() => _AiAssistantPanelState();
}

class _AiAssistantPanelState extends State<AiAssistantPanel> {
  final List<AiMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) {
      return;
    }

    _textController.clear();
    setState(() {
      _messages.add(AiMessage(text: text, isUser: true));
      _isSending = true;
    });
    _scrollToBottom();

    final response = await _getAiResponse(text);

    if (mounted) {
      setState(() {
        _messages.add(AiMessage(text: response, isUser: false));
        _isSending = false;
      });
      _scrollToBottom();
    }
  }

  Future<String> _getAiResponse(String prompt) async {
    // TODO: replace with real API call
    // e.g. Anthropic Claude API with context from DataManager
    await Future.delayed(const Duration(milliseconds: 500));
    return 'This is a placeholder response.';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Expanded(child: _buildMessages()),
          if (_toolActivity != null) _buildToolActivityBar(),
          InputBox(
            onSend: _sendMessage,
            ready: _servicesReady,
            isSending: _isSending,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          const Text(
            'AI Assistant',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          ToolIconButton(
            icon: FontAwesomeIcons.xmark,
            tooltip: 'Close',
            onTap: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          'Ask a question about your data',
          style: TextStyle(fontSize: 13, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: _messages.length + (_isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(AiMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFFDCF5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(message.text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text('…', style: TextStyle(fontSize: 18, color: Colors.black45)),
      ),
    );
  }
}
