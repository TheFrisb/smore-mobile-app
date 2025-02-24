import 'package:smore_mobile_app/models/sport/sport_match.dart';

class Prediction {
  final String status;
  final SportMatch match;
  final String prediction;
  final String detailedAnalysis;
  final double odds;
  final String result;

  Prediction({
    required this.status,
    required this.match,
    required this.prediction,
    required this.detailedAnalysis,
    required this.odds,
    required this.result,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      status: json['status'],
      match: SportMatch.fromJson(json['match']),
      prediction: json['prediction'],
      detailedAnalysis: json['detailed_analysis'],
      odds: double.parse(json['odds'].toString()),
      // Convert String to double
      result: json['result'],
    );
  }
}
