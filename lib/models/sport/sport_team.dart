class SportTeam {
  final String name;
  final String? logoUrl;

  SportTeam({
    required this.name,
    required this.logoUrl,
  });

  factory SportTeam.fromJson(Map<String, dynamic> json) {
    return SportTeam(
      name: json['name'],
      logoUrl: json['logo'],
    );
  }
}
