class SportLeague {
  final String name;
  final String logoUrl;

  SportLeague({
    required this.name,
    required this.logoUrl,
  });

  factory SportLeague.fromJson(Map<String, dynamic> json) {
    return SportLeague(
      name: json['name'],
      logoUrl: json['logo'],
    );
  }
}
