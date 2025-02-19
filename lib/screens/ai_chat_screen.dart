import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';

import 'base/base_app_bar_screen.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BaseAppBarScreen(
      title: "AI Chat",
      padding: const EdgeInsets.all(0),
      backgroundColor: const Color(0xFF0D151E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Center(
                child: Image.network(
                  'https://smoreltd.com/static/assets/images/logo.png',
                  // Replace with your image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      DateChip(
                        color: Theme.of(context).secondaryHeaderColor,
                        date: DateTime(now.year, now.month, now.day - 2),
                      ),
                      const SizedBox(height: 16),
                      const BubbleSpecialOne(
                        text: 'bubble normal without tail',
                        color: Color(0xFFE8E8EE),
                        tail: true,
                        isSender: true,
                      ),
                      const SizedBox(height: 16),
                      const BubbleSpecialThree(
                        text: 'bubble special one with tail',
                        isSender: false,
                        color: Color(0xFF1B97F3),
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                      color: const Color(0xFF1B97F3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
