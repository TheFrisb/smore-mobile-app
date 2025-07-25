// lib/screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/auth/login_screen.dart';
import 'package:smore_mobile_app/screens/wrappers/authenticated_user_screen.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (!userProvider.isInitialized) {
          return const Scaffold(
              backgroundColor: Color(0xFF1e2f42),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        }

        if (userProvider.user == null && !userProvider.isGuest) {
          return const LoginScreen();
        }

        return const AuthenticatedUserScreen();
      },
    );
  }
}
