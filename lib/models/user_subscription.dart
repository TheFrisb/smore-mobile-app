import 'package:smore_mobile_app/models/product.dart';

enum SubscriptionStatus {
  ACTIVE,
  INACTIVE,
}

class UserSubscription {
  final SubscriptionStatus _status;
  final String _frequency;
  final double _price;
  final DateTime _startDate;
  final DateTime _endDate;
  final List<Product> _products;

  UserSubscription({
    required SubscriptionStatus status,
    required String frequency,
    required double price,
    required DateTime startDate,
    required DateTime endDate,
    required List<Product> products,
  })  : _status = status,
        _frequency = frequency,
        _price = price,
        _startDate = startDate,
        _endDate = endDate,
        _products = products;

  // Getter methods
  SubscriptionStatus get status => _status;

  String get frequency => _frequency;

  double get price => _price;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  List<Product> get products => _products;

  bool get isActive => _status == SubscriptionStatus.ACTIVE;

  bool get isInactive => _status == SubscriptionStatus.INACTIVE;

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      status: _parseStatus(json['status']),
      frequency: json['frequency'],
      price: json['price'].toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      products:
          List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
    );
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
}
