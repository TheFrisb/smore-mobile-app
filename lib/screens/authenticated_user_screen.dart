// lib/screens/authenticated_user_screen.dart
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/default_bottom_navigation_bar.dart';
import 'package:smore_mobile_app/screens/ai_chat_screen.dart';
import 'package:smore_mobile_app/screens/history_screen.dart';
import 'package:smore_mobile_app/screens/home_screen.dart';

class AuthenticatedUserScreen extends StatefulWidget {
  const AuthenticatedUserScreen({super.key});

  @override
  State<AuthenticatedUserScreen> createState() =>
      _AuthenticatedUserScreenState();
}

class _AuthenticatedUserScreenState extends State<AuthenticatedUserScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
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
          if (_currentIndex == 2 && index != 2) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
