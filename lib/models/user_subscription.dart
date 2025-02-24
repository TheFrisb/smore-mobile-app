import 'package:smore_mobile_app/models/product.dart';

class UserSubscription {
  final String status;
  final String frequency;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final List<Product> products;

  UserSubscription({
    required this.status,
    required this.frequency,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.products,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      status: json['status'],
      frequency: json['frequency'],
      price: json['price'].toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      products:
          List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
    );
  }
}
