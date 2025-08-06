import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/chat/chat_message.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/service/ai_chat_service.dart';

import '../models/ai/ai_can_send.dart';
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

  // AI message tracking
  AiCanSend? _aiCanSend;
  bool _hasCheckedCanSend = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _checkCanSend();
    });
  }

  @override
  void dispose() {
    _textController.clear();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkCanSend() async {
    try {
      logger.i("Checking AI can send status...");
      _aiCanSend = await _aiChatService.getCanSend();
      logger.i(
          "AI can send response: count=${_aiCanSend?.count}, canSend=${_aiCanSend?.canSend}");
      setState(() {
        _hasCheckedCanSend = true;
      });
      logger.i("Updated hasCheckedCanSend to true");
    } catch (e) {
      logger.e("Error checking AI can send: $e");
      setState(() {
        _hasCheckedCanSend = true;
      });
    }
  }

  void _sendMessage() {
    if (_isProcessing) return;
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      // Check if user is a guest
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final isGuest = userProvider.isGuest;

      if (isGuest) {
        logger.i("Guest user trying to send message, showing login prompt");
        setState(() {
          _messages.add(ChatMessage(
            message: "Log in to access the AI assistant and start chatting!",
            direction: MessageDirection.INBOUND,
          ));
        });
        _textController.clear();
        _scrollToBottom();
        return;
      }

      // Check if user has access to AI or has free messages remaining
      final hasAccess = userProvider.hasAccessToProduct(ProductName.AI_ANALYST);

      if (!hasAccess) {
        // Check if user has used their free messages
        if (_aiCanSend != null && _aiCanSend!.count >= 3) {
          logger.i(
              "User has used all free messages, showing subscription prompt");
          setState(() {
            _messages.add(ChatMessage(
              message:
                  "You've used your 3 free messages. Subscribe to continue chatting with the AI assistant!",
              direction: MessageDirection.INBOUND,
            ));
          });
          _textController.clear();
          _scrollToBottom();
          return;
        }

        // Check if user can send at all
        if (_aiCanSend != null && !_aiCanSend!.canSend) {
          logger.i("User cannot send messages, showing subscription prompt");
          setState(() {
            _messages.add(ChatMessage(
              message:
                  "You need to subscribe to access the AI assistant. Subscribe now to start chatting!",
              direction: MessageDirection.INBOUND,
            ));
          });
          _textController.clear();
          _scrollToBottom();
          return;
        }
      }

      logger.i("Sending message: $text");
      setState(() {
        _messages.add(
            ChatMessage(message: text, direction: MessageDirection.OUTBOUND));
        _isProcessing = true;
      });
      _textController.clear();
      _scrollToBottom();

      final timezone = userProvider.userTimezone ?? 'UTC';
      logger.i("Using timezone: $timezone");
      _aiChatService.sendMessage(text, timezone).then((response) {
        logger.i("AI response received successfully");
        setState(() {
          _messages.add(response);
          _isProcessing = false;
        });
        _scrollToBottom();
        // Refresh can send status after sending message
        logger.i("Refreshing can send status after message sent");
        _checkCanSend();
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
    logger.i("Building AI chat screen");
    logger.i(
        "  - User has AI access: ${userProvider.hasAccessToProduct(ProductName.AI_ANALYST)}");

    return BaseAppBarScreen(
      title: "AI Chat",
      padding: const EdgeInsets.all(0),
      backgroundColor: const Color(0xFF0D151E),
      body: _buildChatInterface(),
    );
  }

  Widget _buildChatInterface() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final hasAccess = userProvider.hasAccessToProduct(ProductName.AI_ANALYST);
    logger.i("Building chat interface:");
    logger.i("  - User has AI access: $hasAccess");
    logger.i("  - AI can send: $_aiCanSend");
    logger.i("  - Count: ${_aiCanSend?.count}");
    logger.i("  - Should show count: ${!hasAccess && _aiCanSend != null}");

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            children: [
              const SizedBox(height: 16),
              ..._messages.map((chatMessage) {
                // Check if this is a login prompt message
                if (chatMessage.message.contains("Log in to access") &&
                    chatMessage.direction == MessageDirection.INBOUND) {
                  return Column(
                    children: [
                      AiChatMessage(chatMessage: chatMessage),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              userProvider.isGuest = false;
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).primaryColor,
                              side: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.logIn,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // Check if this is a subscription prompt message
                if ((chatMessage.message.contains("Subscribe to continue") ||
                        chatMessage.message
                            .contains("Subscribe now to start")) &&
                    chatMessage.direction == MessageDirection.INBOUND) {
                  return Column(
                    children: [
                      AiChatMessage(chatMessage: chatMessage),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagePlanScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).primaryColor,
                              side: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.crown,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'View Plans',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
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
          child: Column(
            children: [
              // Show remaining messages count for users without AI access
              if (!hasAccess && _aiCanSend != null)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15212E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.messageCircle,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${3 - _aiCanSend!.count} free messages remaining',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
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
                          borderSide:
                              const BorderSide(color: Color(0xFF223548)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Color(0xFF223548)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Color(0xFF10648C)),
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
            ],
          ),
        ),
      ],
    );
  }
}
