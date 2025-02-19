import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';

import '../../components/side_drawer.dart';

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
      appBar: const DefaultAppBar(
        showGradient: true,
      ),
      endDrawer: const SideDrawer(),
      body: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
