enum ProductType {
  subscription,
  addon,
}

class Product {
  final int id;
  final String name;
  final String analysesPerMonth;
  final double monthlyPrice;
  final double yearlyPrice;
  final ProductType type;

  Product({
    required this.id,
    required this.name,
    required this.analysesPerMonth,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      analysesPerMonth: json['analysis_per_month'],
      monthlyPrice: double.parse(json['monthly_price']),
      yearlyPrice: double.parse(json['yearly_price']),
      type: _parseProductType(json['type']),
    );
  }

  static ProductType _parseProductType(String type) {
    switch (type) {
      case 'SUBSCRIPTION':
        return ProductType.subscription;
      case 'ADDON':
        return ProductType.addon;
      default:
        throw ArgumentError('Invalid product type: $type');
    }
  }
}
