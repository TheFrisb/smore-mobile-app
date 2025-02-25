class SportCountry {
  final String name;
  final String logoUrl;

  SportCountry({
    required this.name,
    required this.logoUrl,
  });

  factory SportCountry.fromJson(Map<String, dynamic> json) {
    return SportCountry(
      name: json['name'],
      logoUrl: json['logo'],
    );
  }
}
