import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';

import 'base/base_app_bar_screen.dart';

class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({required this.text, required this.isSender});
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  List<ChatMessage> _messages = [
    ChatMessage(text: 'bubble normal without tail', isSender: true),
    ChatMessage(text: 'bubble special one with tail', isSender: false),
  ];
  bool _isAiThinking = false;
  bool _isProcessing = false;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_isProcessing) return; // Prevent sending if already processing
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _isProcessing = true; // Disable input immediately
        _messages
            .add(ChatMessage(text: text, isSender: true)); // Add user's message
      });
      _textController.clear();
      _scrollToBottom();

      // After 0.5 seconds, show "Thinking..." bubble
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isAiThinking = true;
          });
          _scrollToBottom();
        }
      });

      // After total 4.5 seconds (0.5s delay + 4s thinking), add AI response
      Future.delayed(Duration(seconds: 4, milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isAiThinking = false; // Hide "Thinking..." bubble
            _isProcessing = false; // Enable input
            _messages.add(ChatMessage(
                text:
                    "Brighton holds a strong home advantage, having won their last three Premier League matches against Bournemouth at the Amex Stadium. Bournemouth faces defensive challenges with key players like Illia Zabarnyi suspended and Marcos Senesi out, potentially weakening their backline. Opta's supercomputer gives Brighton a 40.5% chance of winning, compared to Bournemouth's 32.8%, reflecting Brighton's slight edge. Both teams are offensive-minded, with Brighton averaging 1.6 goals per game and Bournemouth 1.7, suggesting a high-scoring affair. Betting on over 2.5 goals at odds of 1.62 is recommended due to their scoring tendencies and recent form.\n\nRecommended Bet: Over 2.5 goals",
                isSender: false));
          });
          _scrollToBottom();
        }
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BaseAppBarScreen(
      title: "AI Chat",
      padding: const EdgeInsets.all(0),
      backgroundColor: const Color(0xFF0D151E),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                DateChip(
                  color: Theme.of(context).secondaryHeaderColor,
                  date: DateTime(now.year, now.month, now.day - 2),
                ),
                const SizedBox(height: 16),
                ..._messages.map((message) {
                  if (message.isSender) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BubbleSpecialOne(
                        text: message.text,
                        color: Color(0xFFE8E8EE),
                        tail: true,
                        isSender: true,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BubbleSpecialThree(
                        text: message.text,
                        color: Color(0xFF1B97F3),
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                        isSender: false,
                      ),
                    );
                  }
                }).toList(),
                if (_isAiThinking)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BubbleSpecialThree(
                      text: 'Thinking...',
                      color: Color(0xFF1B97F3),
                      textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      isSender: false,
                    ),
                  ),
              ],
            ),
          ),
          const BrandGradientLine(),
          Container(
            color: const Color(0xFF0D151E),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    enabled: !_isProcessing,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF15212E),
                      labelText: 'Enter your message here',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(color: Color(0xFF223548)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(color: Color(0xFF223548)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(color: Color(0xFF10648C)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: const Color(0xFF1B97F3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
