import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double? fontSize;

  const BrandLogo({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
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
          fontSize: fontSize ?? 14,
          color: Colors.white, // Base text color (required for gradient)
        ),
      ),
    );
  }
}
