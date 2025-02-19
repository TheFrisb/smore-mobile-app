// lib/screens/root_screen.dart
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/default_bottom_navigation_bar.dart';
import 'package:smore_mobile_app/screens/ai_chat_screen.dart';
import 'package:smore_mobile_app/screens/home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AiChatScreen(),
  ];

  @override
  build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Unfocus when switching away from AiChatScreen (index 1)
          if (_currentIndex == 1 && index != 1) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
