import 'package:smore_mobile_app/models/sport/sport_league.dart';
import 'package:smore_mobile_app/models/sport/sport_team.dart';
import 'package:smore_mobile_app/models/sport/sport_type.dart';

class SportMatch {
  final SportLeague league;
  final SportTeam homeTeam;
  final SportTeam awayTeam;
  final DateTime kickoffDateTime;
  final String homeTeamScore;
  final String awayTeamScore;
  final SportType type;

  SportMatch({
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoffDateTime,
    required this.type,
    required this.homeTeamScore,
    required this.awayTeamScore,
  });

  factory SportMatch.fromJson(Map<String, dynamic> json) {
    return SportMatch(
      league: SportLeague.fromJson(json['league']),
      homeTeam: SportTeam.fromJson(json['home_team']),
      awayTeam: SportTeam.fromJson(json['away_team']),
      kickoffDateTime: DateTime.parse(json['kickoff_datetime']),
      type: _parseSportType(json['type']),
      homeTeamScore: json['home_team_score'],
      awayTeamScore: json['away_team_score'],
    );
  }

  static SportType _parseSportType(String sportType) {
    switch (sportType) {
      case 'SOCCER':
        return SportType.SOCCER;
      case 'BASKETBALL':
        return SportType.BASKETBALL;
      case 'TENNIS':
        return SportType.TENNIS;
      case 'NFL':
        return SportType.NFL;
      case 'NHL':
        return SportType.NHL;
      default:
        throw Exception('Invalid sport type: $sportType');
    }
  }
}
