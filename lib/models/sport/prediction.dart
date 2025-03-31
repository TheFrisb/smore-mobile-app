import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/sport_match.dart';

enum PredictionStatus { PENDING, WON, LOST }

class Prediction {
  final int id;
  final PredictionStatus status;
  final SportMatch match;
  final String prediction;
  final String detailedAnalysis;
  final double odds;
  final String result;
  final Product product;

  Prediction({
    required this.id,
    required this.status,
    required this.match,
    required this.prediction,
    required this.detailedAnalysis,
    required this.odds,
    required this.result,
    required this.product,
  });

  bool get hasDetailedAnalysis => detailedAnalysis.isNotEmpty;

  bool get isPending => status == PredictionStatus.PENDING;

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['id'],
      status: _parseStatus(json["status"]),
      match: SportMatch.fromJson(json['match']),
      prediction: json['prediction'],
      detailedAnalysis: json['detailed_analysis'],
      odds: double.parse(json['odds'].toString()),
      result: json['result'],
      product: Product.fromJson(json['product']),
    );
  }

  static PredictionStatus _parseStatus(String status) {
    switch (status) {
      case 'PENDING':
        return PredictionStatus.PENDING;
      case 'WON':
        return PredictionStatus.WON;
      case 'LOST':
        return PredictionStatus.LOST;
      default:
        throw Exception('Unknown prediction status: $status');
    }
  }
}
