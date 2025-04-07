import 'package:smore_mobile_app/models/product.dart';

enum SubscriptionStatus {
  ACTIVE,
  INACTIVE,
}

enum SubscriptionFrequency {
  MONTHLY,
  YEARLY,
}

enum SubscriptionProviderType {
  STRIPE,
  APPLE,
  GOOGLE,
}

extension SubscriptionStatusExtension on SubscriptionStatus {
  String get displayName {
    switch (this) {
      case SubscriptionStatus.ACTIVE:
        return 'Active';
      case SubscriptionStatus.INACTIVE:
        return 'Inactive';
    }
  }

  String get toQueryParameter {
    switch (this) {
      case SubscriptionStatus.ACTIVE:
        return 'active';
      case SubscriptionStatus.INACTIVE:
        return 'inactive';
    }
  }
}

extension SubscriptionFrequencyExtension on SubscriptionFrequency {
  String get displayName {
    switch (this) {
      case SubscriptionFrequency.MONTHLY:
        return 'Monthly';
      case SubscriptionFrequency.YEARLY:
        return 'Yearly';
    }
  }

  String get nounDisplayName {
    switch (this) {
      case SubscriptionFrequency.MONTHLY:
        return 'month';
      case SubscriptionFrequency.YEARLY:
        return 'year';
    }
  }

  String get toQueryParameter {
    switch (this) {
      case SubscriptionFrequency.MONTHLY:
        return 'monthly';
      case SubscriptionFrequency.YEARLY:
        return 'yearly';
    }
  }
}

extension SubscriptionProviderTypeExtension on SubscriptionProviderType {
  String get displayName {
    switch (this) {
      case SubscriptionProviderType.STRIPE:
        return 'Stripe';
      case SubscriptionProviderType.APPLE:
        return 'Apple';
      case SubscriptionProviderType.GOOGLE:
        return 'Google';
    }
  }

  String get toQueryParameter {
    switch (this) {
      case SubscriptionProviderType.STRIPE:
        return 'STRIPE';
      case SubscriptionProviderType.APPLE:
        return 'APPLE';
      case SubscriptionProviderType.GOOGLE:
        return 'GOOGLE';
    }
  }
}

class UserSubscription {
  final SubscriptionStatus _status;
  final SubscriptionFrequency _frequency;
  final SubscriptionProviderType _providerType;
  final double _price;
  final DateTime _startDate;
  final DateTime _endDate;
  final List<Product> _products;
  final Product _firstChosenProduct;

  UserSubscription(
      {required SubscriptionStatus status,
      required SubscriptionFrequency frequency,
      required SubscriptionProviderType providerType,
      required double price,
      required DateTime startDate,
      required DateTime endDate,
      required List<Product> products,
      required Product firstChosenProduct})
      : _status = status,
        _frequency = frequency,
        _providerType = providerType,
        _price = price,
        _startDate = startDate,
        _endDate = endDate,
        _products = products,
        _firstChosenProduct = firstChosenProduct;

  // Getter methods
  SubscriptionStatus get status => _status;

  SubscriptionFrequency get frequency => _frequency;

  SubscriptionProviderType get providerType => _providerType;

  double get price => _price;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  List<Product> get products => _products;

  bool get isActive => _status == SubscriptionStatus.ACTIVE;

  bool get isInactive => _status == SubscriptionStatus.INACTIVE;

  bool get isMonthly => _frequency == SubscriptionFrequency.MONTHLY;

  Product get firstChosenProduct => _firstChosenProduct;

  bool containsProduct(Product product) {
    return _products.any((p) => p.id == product.id);
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      status: _parseStatus(json['status']),
      frequency: _parseFrequency(json['frequency']),
      providerType: _parseProviderType(json['provider_type']),
      price: json['price'].toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      products:
          List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
      firstChosenProduct: Product.fromJson(json['first_chosen_product']),
    );
  }

  double getProductSalePrice(Product product) {
    // check if the product is present in the list of products
    if (!containsProduct(product)) {
      throw Exception('Product not found in subscription');
    }

    if (product.id == firstChosenProduct.id) {
      return product.getSalePrice(isMonthly, false);
    } else {
      bool isDiscounted = products.length > 1;
      return product.getSalePrice(isMonthly, isDiscounted);
    }
  }

  static SubscriptionStatus _parseStatus(String status) {
    switch (status) {
      case 'active':
        return SubscriptionStatus.ACTIVE;
      case 'inactive':
        return SubscriptionStatus.INACTIVE;
      default:
        throw Exception('Unknown subscription status: $status');
    }
  }

  static SubscriptionFrequency _parseFrequency(String frequency) {
    switch (frequency) {
      case 'monthly':
        return SubscriptionFrequency.MONTHLY;
      case 'yearly':
        return SubscriptionFrequency.YEARLY;
      default:
        throw Exception('Unknown subscription frequency: $frequency');
    }
  }

  static SubscriptionProviderType _parseProviderType(String providerType) {
    switch (providerType) {
      case 'STRIPE':
        return SubscriptionProviderType.STRIPE;
      case 'APPLE':
        return SubscriptionProviderType.APPLE;
      case 'GOOGLE':
        return SubscriptionProviderType.GOOGLE;
      default:
        throw Exception('Unknown subscription provider type: $providerType');
    }
  }
}
