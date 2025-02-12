// lib/screens/root_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';


class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
