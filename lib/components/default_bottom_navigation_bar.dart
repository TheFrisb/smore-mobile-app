import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'decoration/brand_gradient_line.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  const DefaultBottomNavigationBar({super.key});

  static final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight + 4,
      child: Column(
        children: [
          const BrandGradientLine(height: 1.5),
          BottomNavigationBar(
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
            onTap: (index) {
              logger.i("Bottom navigation bar tapped, index: $index");
            },
          ),
        ],
      ),
    );
  }
}
