import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/base_app_bar.dart';

class BaseAppBarScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const BaseAppBarScreen({
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
      appBar: const BaseAppBar(),
      body: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
