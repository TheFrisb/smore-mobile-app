// Enums remain unchanged as they follow Dart conventions (uppercase with underscores)
enum ProductType {
  SUBSCRIPTION,
  ADDON,
}

enum ProductName {
  SOCCER,
  BASKETBALL,
  AI_ANALYST,
  NFL_NHL_NCAA,
  TENNIS,
}

const Map<String, ProductType> _productTypeMap = {
  'SUBSCRIPTION': ProductType.SUBSCRIPTION,
  'ADDON': ProductType.ADDON,
};

const Map<String, ProductName> _productNameMap = {
  'Soccer': ProductName.SOCCER,
  'Basketball': ProductName.BASKETBALL,
  'Tennis': ProductName.TENNIS,
  'AI Analyst': ProductName.AI_ANALYST,
  'NFL_NHL_NCAA': ProductName.NFL_NHL_NCAA,
};

const Map<ProductName, String> _displayNames = {
  ProductName.SOCCER: 'Soccer',
  ProductName.BASKETBALL: 'Basketball',
  ProductName.TENNIS: 'Tennis',
  ProductName.AI_ANALYST: 'AI Analyst',
  ProductName.NFL_NHL_NCAA: 'NFL, NHL, NCAA',
};

extension ProductNameExtension on ProductName {
  String get displayName => _displayNames[this]!;

  String toQueryParameter() {
    if (this != ProductName.NFL_NHL_NCAA) {
      return displayName;
    } else {
      return 'NFL_NHL_NCAA';
    }
  }
}

class Product {
  final int id;
  final ProductName name;
  final String analysesPerMonth;
  final double monthlyPrice;
  final double discountedMonthlyPrice;
  final double yearlyPrice;
  final double discountedYearlyPrice;
  final ProductType type;

  Product({
    required this.id,
    required this.name,
    required this.analysesPerMonth,
    required this.monthlyPrice,
    required this.discountedMonthlyPrice,
    required this.yearlyPrice,
    required this.discountedYearlyPrice,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final nameStr = json['name'] as String;
    final analysesPerMonth = json['analysis_per_month'] as String;
    final monthlyPrice = double.parse(json['monthly_price'] as String);
    final discountedMonthlyPrice =
        double.parse(json['discounted_monthly_price'] as String);
    final yearlyPrice = double.parse(json['yearly_price'] as String);
    final discountedYearlyPrice =
        double.parse(json['discounted_yearly_price'] as String);
    final typeStr = json['type'] as String;

    final nameEnum = _productNameMap[nameStr] ??
        (throw ArgumentError('Invalid product name: $nameStr'));
    final typeEnum = _productTypeMap[typeStr] ??
        (throw ArgumentError('Invalid product type: $typeStr'));

    return Product(
      id: id,
      name: nameEnum,
      analysesPerMonth: analysesPerMonth,
      monthlyPrice: monthlyPrice,
      discountedMonthlyPrice: discountedMonthlyPrice,
      yearlyPrice: yearlyPrice,
      discountedYearlyPrice: discountedYearlyPrice,
      type: typeEnum,
    );
  }

  double getSalePrice(bool isMonthly, bool isDiscounted) {
    if (isMonthly) {
      return isDiscounted ? discountedMonthlyPrice : monthlyPrice;
    } else {
      return isDiscounted ? discountedYearlyPrice : yearlyPrice;
    }
  }

  String get displayName => _displayNames[name]!;
}
