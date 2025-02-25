import 'package:smore_mobile_app/models/sport/Country.dart';

class SportLeague {
  final String name;
  final String logoUrl;
  final SportCountry country;

  SportLeague({
    required this.name,
    required this.logoUrl,
    required this.country,
  });

  factory SportLeague.fromJson(Map<String, dynamic> json) {
    return SportLeague(
      name: json['name'],
      logoUrl: json['logo'],
      country: SportCountry.fromJson(json['country']),
    );
  }
}
