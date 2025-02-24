class Product {
  final String name;
  final String analysesPerMonth;

  Product({
    required this.name,
    required this.analysesPerMonth,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      analysesPerMonth: json['analysis_per_month'],
    );
  }
}
