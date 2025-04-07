import 'package:flutter/material.dart';

class PredictionText extends StatelessWidget {
  final String predictionText;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;

  const PredictionText(
      {super.key,
      required this.predictionText,
      required this.fontSize,
      required this.color,
      required this.textAlign});

  /*
  * Format the prediction text to be more readable.
  * If the prediction contains &, then break it into two lines.
  * Example 1: Draw or Inter & Over 1.5 goals
  * Result:
  * -- Draw or Inter &
  * -- Over 1.5 goals
  * */

  String getFormattedPredictionText(String text) {
    if (text.contains('&')) {
      final parts = text.split('&');
      return '${parts[0].trim()} &\n${parts[1].trim()}';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getFormattedPredictionText(predictionText),
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
