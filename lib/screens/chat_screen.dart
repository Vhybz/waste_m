
import 'package:cjt_scan/services/chat_service.dart';
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text': 'Hello! I am your AnemiaScan AI Assistant. I can provide information about anemia and screening. How can I help you today?'
    }
  ];
  bool _isTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
      _controller.clear();
    });
    _scrollToBottom();

    final response = await _chatService.sendMessage(text);

    if (mounted) {
      setState(() {
        _messages.add({'role': 'assistant', 'text': response});
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Health Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildSafetyWarning(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(
                  text: msg['text']!,
                  isUser: msg['role'] == 'user',
                );
              },
            ),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildQuickSuggestions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSafetyWarning() {
    return Container(
      width: double.infinity,
      color: Colors.amber.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: Colors.amber.shade900),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Assistant is an AI, not a doctor. Only blood tests diagnose anemia.',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text('Assistant is thinking...', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    final suggestions = ['What is anemia?', 'How to take a better scan?', 'Symptoms of anemia'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(suggestions[index], style: const TextStyle(fontSize: 12)),
              onPressed: () => _sendMessage(suggestions[index]),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade200),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ask a health question...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [if (!isUser) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }
}
