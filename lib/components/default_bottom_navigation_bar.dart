import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
      height: kBottomNavigationBarHeight + 4,
      child: Column(
        children: [
          const BrandGradientLine(height: 1),
          BottomNavigationBar(
            currentIndex: currentIndex,
            items: const [
              BottomNavigationBarItem(
                label: 'Predictions',
                icon: Icon(Icons.insights_outlined),
              ),
              BottomNavigationBarItem(
                label: 'AI Chat',
                icon: Icon(Icons.chat_bubble_outline),
              ),
            ],
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
