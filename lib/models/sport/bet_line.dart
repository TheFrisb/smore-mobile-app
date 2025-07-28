import 'package:smore_mobile_app/models/sport/sport_match.dart';

class BetLine {
  final int id;
  final SportMatch match;
  final String bet;
  final String betType;
  final double odds;
  final DateTime createdAt;

  BetLine({
    required this.id,
    required this.match,
    required this.bet,
    required this.betType,
    required this.odds,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'BetLine(id: $id, match: $match, bet: $bet, betType: $betType, odds: $odds, createdAt: $createdAt)';
  }

  factory BetLine.fromJson(Map<String, dynamic> json) {
    return BetLine(
      id: json['id'],
      match: SportMatch.fromJson(json['match']),
      bet: json['bet'],
      betType: json['bet_type'],
      odds: (json['odds'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
