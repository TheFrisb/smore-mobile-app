import 'package:smore_mobile_app/models/sport/sport_league.dart';
import 'package:smore_mobile_app/models/sport/sport_team.dart';

class SportMatch {
  final SportLeague league;
  final SportTeam homeTeam;
  final SportTeam awayTeam;
  final DateTime kickoffDateTime;

  SportMatch({
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoffDateTime,
  });

  factory SportMatch.fromJson(Map<String, dynamic> json) {
    return SportMatch(
      league: SportLeague.fromJson(json['league']),
      homeTeam: SportTeam.fromJson(json['home_team']),
      awayTeam: SportTeam.fromJson(json['away_team']),
      kickoffDateTime: DateTime.parse(json['kickoff_datetime']),
    );
  }
}
