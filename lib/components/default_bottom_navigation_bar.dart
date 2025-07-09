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
                icon: Icon(Icons.insights_outlined),
              ),
              BottomNavigationBarItem(
                label: 'History',
                icon: Icon(Icons.history_outlined),
              ),
              BottomNavigationBarItem(
                label: 'AI Analyst',
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
