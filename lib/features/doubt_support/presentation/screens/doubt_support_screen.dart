import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';

class MessageBubble {
  final String text;
  final bool isUser;
  final DateTime time;

  MessageBubble({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class DoubtSupportScreen extends StatefulWidget {
  const DoubtSupportScreen({super.key});

  @override
  State<DoubtSupportScreen> createState() => _DoubtSupportScreenState();
}

class _DoubtSupportScreenState extends State<DoubtSupportScreen> {
  final List<MessageBubble> _messages = [
    MessageBubble(
      text: "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. Ask me anything related to your homework, PDFs, or computer courses!",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(MessageBubble(text: text, isUser: true, time: DateTime.now()));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      String aiResponse = "That's a great question! Here's a brief breakdown: ";
      if (text.toLowerCase().contains("fraction")) {
        aiResponse += "A fraction represents a part of a whole. It consists of a numerator (top number) and a denominator (bottom number). For example, 1/2 means one part out of two equal parts.";
      } else if (text.toLowerCase().contains("computer") || text.toLowerCase().contains("ram")) {
        aiResponse += "RAM (Random Access Memory) is the primary volatile memory of a computer that temporarily stores data that is actively being used by the CPU for rapid retrieval.";
      } else {
        aiResponse += "I am checking the Agarwal Knowledge Hub reference manuals for detailed notes. Please consult Ms. Anjali Verma for class specific updates.";
      }

      setState(() {
        _messages.add(MessageBubble(text: aiResponse, isUser: false, time: DateTime.now()));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Doubt Support'),
      ),
      body: Column(
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.secondaryOrange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI tutor solves questions instantly from your textbooks and PDFs.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Messages thread
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppColors.primaryBlue
                          : (isDark ? AppColors.darkSurface : Colors.grey[200]),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                        bottomRight: Radius.circular(msg.isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondaryOrange),
                ),
              ),
            ),
            
          // Input bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type your doubt here...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primaryBlue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
