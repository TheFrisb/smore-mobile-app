import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'decoration/brand_gradient_line.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DefaultBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight +
          MediaQuery.viewPaddingOf(context).bottom +
          3,
      child: Column(
        children: [
          const BrandGradientLine(height: 1),
          BottomNavigationBar(
            currentIndex: currentIndex,
            items: const [
              BottomNavigationBarItem(
                label: 'Predictions',
                icon: Icon(LucideIcons.listOrdered),
              ),
              BottomNavigationBarItem(
                label: 'History',
                icon: Icon(LucideIcons.history),
              ),
              BottomNavigationBarItem(
                label: 'AI Analyst',
                icon: Icon(LucideIcons.bot),
              ),
            ],
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
