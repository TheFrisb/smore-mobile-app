import 'package:flutter/material.dart';

class BrandGradientLine extends StatelessWidget {
  const BrandGradientLine({
    super.key,
    this.height,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF0BA5EC).withOpacity(0.5),
            Colors.transparent,
          ],
          stops: const [0.1, 0.5, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
