import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/chat/chat_message.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/service/ai_chat_service.dart';

import '../app_colors.dart';
import '../models/ai/chat_message.dart';
import '../models/product.dart';
import 'base/base_app_bar_screen.dart';
import 'manage_plan_screen.dart';

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
                icon: const Icon(LucideIcons.send),
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
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool isGuest = userProvider.isGuest;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enhanced icon container with better gradient and shadow
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.3),
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  LucideIcons.bot,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              // Enhanced main title with gradient text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      'AI Analyst Locked',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.lock,
                    color: Colors.red,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Enhanced subtitle
              Text(
                isGuest
                    ? 'You need to sign up to access AI features'
                    : 'Subscribe to unlock AI-powered analysis',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFdbe4ed),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Enhanced description container with better styling
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0D151E).withOpacity(0.8),
                      const Color(0xFF0D151E).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Get AI-powered sports analysis and predictions',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFdbe4ed),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.2),
                            Theme.of(context).primaryColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ManagePlanScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.crown,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Subscribe',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                LucideIcons.arrowRight,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'to access AI Analyst',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary.shade100,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
