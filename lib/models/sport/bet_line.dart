import 'package:smore_mobile_app/models/sport/sport_match.dart';

enum BetLineStatus {
  PENDING,
  WON,
  LOST,
}

class BetLine {
  final int id;
  final SportMatch match;
  final String bet;
  final String betType;
  final double odds;
  final BetLineStatus status;

  BetLine({
    required this.id,
    required this.match,
    required this.bet,
    required this.betType,
    required this.odds,
    required this.status,
  });

  @override
  String toString() {
    return 'BetLine(id: $id, match: $match, bet: $bet, betType: $betType, odds: $odds, status: $status)';
  }

  factory BetLine.fromJson(Map<String, dynamic> json) {
    print('Parsing BetLine JSON: ${json.keys}');
    try {
      return BetLine(
        id: json['id'],
        match: SportMatch.fromJson(json['match']),
        bet: json['bet'],
        betType: json['bet_type'], // This should match the JSON field name
        odds: double.parse(json['odds'].toString()),
        status: BetLineStatus.values
            .firstWhere((e) => e.toString() == 'BetLineStatus.${json['status']}'),
      );
    } catch (e) {
      print('Error parsing BetLine JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
