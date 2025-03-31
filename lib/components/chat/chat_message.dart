import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smore_mobile_app/models/ai/chat_message.dart';

import '../../app_colors.dart';

class AiChatMessage extends StatelessWidget {
  final ChatMessage chatMessage;

  const AiChatMessage({
    super.key,
    required this.chatMessage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutbound = chatMessage.direction == MessageDirection.OUTBOUND;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment:
            isOutbound ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primary.shade800.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft:
                        isOutbound ? const Radius.circular(20) : Radius.zero,
                    bottomRight:
                        isOutbound ? Radius.zero : const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1,
                  )),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Markdown(
                  data: chatMessage.message,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  styleSheet: MarkdownStyleSheet(
                      h1: _buildPrimaryColorTextStyle(context, 20),
                      h2: _buildPrimaryColorTextStyle(context, 20),
                      h3: _buildPrimaryColorTextStyle(context, 18),
                      h4: _buildPrimaryColorTextStyle(context, 16),
                      h5: _buildPrimaryColorTextStyle(context, 16),
                      h6: _buildPrimaryColorTextStyle(context, 16),
                      p: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ))),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _buildPrimaryColorTextStyle(BuildContext context, double fontSize) {
    return TextStyle(fontSize: fontSize, color: Theme.of(context).primaryColor);
  }
}
