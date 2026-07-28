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
      
      String aiResponse = "";
      final query = text.toLowerCase();
      
      if (query.contains("fraction")) {
        aiResponse = "That's a great question! Here's a brief breakdown: A fraction represents a part of a whole. It consists of a numerator (top number) and a denominator (bottom number). For example, 1/2 means one part out of two equal parts. To add fractions with the same denominator, simply add the numerators!";
      } else if (query.contains("computer") || query.contains("ram") || query.contains("cpu") || query.contains("hardware")) {
        aiResponse = "Excellent question about Computer Basics! Computers process data using the CPU (Central Processing Unit), which is the brain. RAM (Random Access Memory) holds active data temporarily. Input devices like keyboard/mouse let you send instructions, and output devices like monitor display results.";
      } else if (query.contains("admission") || query.contains("join") || query.contains("fee") || query.contains("class")) {
        aiResponse = "Welcome! Admissions are open at Agarwal Knowledge Hub. We provide excellent conceptual courses in Computer Science, CBSE Mathematics, and interactive Science labs. Our fees are very reasonable. Please consult Director Agarwal or Ms. Anjali Verma at the office to get the registration booklet!";
      } else if (query.contains("homework") || query.contains("assignment") || query.contains("due")) {
        aiResponse = "You can access all assigned homework sheets under the 'Homework' tab in your portal. You can download the PDF worksheets, solve them, and submit snapshots directly from the 'Submit' screen. If you have any specific query from a worksheet, type it here!";
      } else if (query.contains("hi") || query.contains("hello") || query.contains("hey") || query.contains("helo")) {
        aiResponse = "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. I can help you solve doubts on Mathematics, Computer Science, and general classroom homework. What subject are you studying today?";
      } else if (query.contains("thank") || query.contains("thanks")) {
        aiResponse = "You're very welcome! Learning is a journey, and we are happy to support you. Let me know if you have any other questions!";
      } else {
        aiResponse = "That's an interesting question about '${text}'. Let's analyze:\n1. At Agarwal Knowledge Hub, we recommend checking the study materials in your 'Notes' tab.\n2. For this topic, try to review the textbook chapters first.\n3. If you need step-by-step guidance, Ms. Anjali Verma will cover this in the next live doubt clearing session!";
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
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                    ),
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
