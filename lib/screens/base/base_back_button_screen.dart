import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/app_bars/back_button_app_bar.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final EdgeInsetsGeometry? padding;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e2f42),
      appBar: BackButtonAppBar(title: title),
      body: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
