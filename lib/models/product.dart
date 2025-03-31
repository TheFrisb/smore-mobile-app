enum ProductType {
  subscription,
  addon,
}

enum ProductName {
  SOCCER,
  BASKETBALL,
  TENNIS,
  AI_ANALYST,
  NFL_NHL_NCAA,
}

class Product {
  final int id;
  final ProductName name;
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
      name: _parseProductName(json['name']),
      analysesPerMonth: json['analysis_per_month'],
      monthlyPrice: double.parse(json['monthly_price']),
      yearlyPrice: double.parse(json['yearly_price']),
      type: _parseProductType(json['type']),
    );
  }

  static ProductName _parseProductName(String name) {
    switch (name) {
      case 'Soccer':
        return ProductName.SOCCER;
      case 'Basketball':
        return ProductName.BASKETBALL;
      case 'Tennis':
        return ProductName.TENNIS;
      case 'AI Analyst':
        return ProductName.AI_ANALYST;
      case 'NFL_NHL_NCAA':
        return ProductName.NFL_NHL_NCAA;
      default:
        throw ArgumentError('Invalid product name: $name');
    }
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
