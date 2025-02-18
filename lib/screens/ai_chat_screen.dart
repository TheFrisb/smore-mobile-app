import 'package:flutter/material.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: "AI Chat",
      padding: EdgeInsets.all(0),
      backgroundColor: Color(0xFF0D151E),
      body: Text("This is the AI Chat Nigga"),
    );
  }
}
