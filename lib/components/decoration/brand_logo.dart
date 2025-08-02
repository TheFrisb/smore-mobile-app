import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double? fontSize;

  const BrandLogo({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background text for proper sizing
        Text(
          "SMORE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize ?? 24,
            color: Colors.transparent,
          ),
        ),
        // Gradient overlay
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFFFFFFF), // #FFF
                Color(0xFFB7C9DB), // #b7c9db
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            "SMORE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 24,
              height: 1.2, // Increased line height to prevent clipping
              color: Colors.white, // Required for gradient
            ),
          ),
        ),
      ],
    );
  }
}
