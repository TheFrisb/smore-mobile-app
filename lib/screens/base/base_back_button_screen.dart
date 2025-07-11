import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/app_bars/back_button_app_bar.dart';

class BaseBackButtonScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const BaseBackButtonScreen({
    super.key,
    required this.title,
    required this.body,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? const Color(0xFF1e2f42),
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
