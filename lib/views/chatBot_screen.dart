import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotScreen extends StatefulWidget {
  final String? initialMessage;
  final bool? checkArrow;

  const ChatBotScreen({super.key, this.initialMessage, this.checkArrow = false});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late final GenerativeModel _model;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showApiKeyError();
      });
    } else {
      _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
      if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _sendInitial(widget.initialMessage!);
        });
      }
    }
  }

  void _showApiKeyError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lỗi API Key'),
        content: const Text('Không tìm thấy API_KEY trong file .env'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendInitial(String text) async {
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });
    _scrollToBottom();
    try {
      final response = await _model.generateContent([Content.text(text)]);
      final botReply =
          response.text ?? "Xin lỗi, tôi không thể trả lời lúc này.";
      setState(() {
        _messages.add({'sender': 'bot', 'text': botReply});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': '❗ Đã xảy ra lỗi: $e'});
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _messageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _model.generateContent([Content.text(text)]);
      final botReply =
          response.text ?? "Xin lỗi, tôi không thể trả lời lúc này.";
      setState(() {
        _messages.add({'sender': 'bot', 'text': botReply});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': '❗ Đã xảy ra lỗi: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(String sender, String text) {
    final baseStyle = MarkdownStyleSheet.fromTheme(Theme.of(context));
    final customStyle = baseStyle.copyWith(
      p: baseStyle.p?.copyWith(
        fontSize: 18,
        color: sender == 'user' ? Colors.white : Colors.amberAccent,
      ),
      listBullet: baseStyle.listBullet?.copyWith(
        fontSize: 18,
        color: sender == 'user' ? Colors.white70 : Colors.white60,
      ),
    );

    return Align(
      alignment:
          sender == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sender == 'user' ? Colors.blueAccent : Colors.white24,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MarkdownBody(
          data: text,
          styleSheet: customStyle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.checkArrow == true) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                  if (widget.checkArrow == false) ...[
                    const IconButton(
                      icon: Icon(Icons.eco, color: Colors.lightGreenAccent, size: 30),
                      onPressed: null
                    ),
                  ],
                  const SizedBox(width: 10),
                  const Row(
                    children: [
                      Text(
                        "Trợ lý AI PushanPlant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.smart_toy_outlined,
                          color: Colors.lightGreenAccent)
                    ],
                  )
                ],
              ),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),
              const Text(
                "Bạn cần gì? Hãy cho tôi biết nhé, tôi sẽ giúp bạn.",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == _messages.length) {
                        return _buildMessage('bot', 'Đang nhập...');
                      }
                      final msg = _messages[index];
                      return _buildMessage(msg['sender']!, msg['text']!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.amberAccent),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
