import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/chat/chat_message.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/service/ai_chat_service.dart';

import '../app_colors.dart';
import '../models/ai/chat_message.dart';
import '../models/product.dart';
import 'base/base_app_bar_screen.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AiChatService _aiChatService = AiChatService();
  final List<ChatMessage> _messages = [
    ChatMessage(
        message:
            "Hello! I'm your AI Analyst! Ask me anything about sport matches analysis and predictions.",
        direction: MessageDirection.INBOUND),
  ];
  static final Logger logger = Logger();
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
    _textController.clear();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_isProcessing) return;
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(
            ChatMessage(message: text, direction: MessageDirection.OUTBOUND));
        _isProcessing = true;
      });
      _textController.clear();
      _scrollToBottom();

      _aiChatService.sendMessage(text).then((response) {
        setState(() {
          _messages.add(response);
          _isProcessing = false;
        });
        _scrollToBottom();
      }).catchError((e) {
        logger.e("Error sending message: $e");
        setState(() {
          _messages.add(ChatMessage(
            message:
                "An unexpected error has occurred. Please try again or contact support if the issue persists.",
            direction: MessageDirection.INBOUND,
          ));
          _isProcessing = false;
        });
        _scrollToBottom();
      });
    }
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
    final userProvider = Provider.of<UserProvider>(context);

    return BaseAppBarScreen(
      title: "AI Chat",
      padding: const EdgeInsets.all(0),
      backgroundColor: const Color(0xFF0D151E),
      body: userProvider.hasAccessToProduct(ProductName.AI_ANALYST)
          ? _buildChatInterface()
          : _buildLockedSection(context),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            children: [
              const SizedBox(height: 16),
              ..._messages.map((chatMessage) {
                return AiChatMessage(chatMessage: chatMessage);
              }),
              if (_isProcessing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AiChatMessage(
                    chatMessage: ChatMessage(
                      message: "Loading...",
                      direction: MessageDirection.INBOUND,
                    ),
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
    );
  }

  Widget _buildLockedSection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AI Analyst locked',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.lock_outline,
                color: Colors.red,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const BrandGradientLine(),
          const SizedBox(height: 16),
          // Container(
          //   width: 200,
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF14202D).withOpacity(0.5),
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(
          //       color: const Color(0xFF1E3A5A).withOpacity(0.5),
          //     ),
          //   ),
          //   child: InkWell(
          //     onTap: () {
          //       // TODO: Navigate to subscription page
          //     },
          //     child: Padding(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'Subscribe',
          //             style: TextStyle(
          //               color: Theme.of(context).primaryColor,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Icon(
          //             Icons.arrow_forward,
          //             color: Theme.of(context).primaryColor,
          //             size: 20,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 8),
          Text(
            'You can obtain AI access from our website',
            style: TextStyle(
              color: AppColors.secondary.shade100,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
