import 'package:flutter/material.dart';
import 'package:smore_mobile_app/screens/root_screen.dart';
import 'package:smore_mobile_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.dark,
      home: const RootScreen(),
    );
  }
}
