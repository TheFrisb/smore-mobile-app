// user.dart
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';

class User {
  final int _id;
  final String _username;
  final String _email;
  final String _firstName;
  final String _lastName;
  final bool _isEmailVerified;
  final UserSubscription? _userSubscription;

  User({
    required int id,
    required String username,
    required String email,
    required bool isEmailVerified,
    required String firstName,
    required String lastName,
    UserSubscription? userSubscription,
  })  : _id = id,
        _username = username,
        _email = email,
        _isEmailVerified = isEmailVerified,
        _firstName = firstName,
        _lastName = lastName,
        _userSubscription = userSubscription;

  // Getter methods for external access
  int get id => _id;

  String get username => _username;

  String get email => _email;

  bool get isEmailVerified => _isEmailVerified;

  String get firstName => _firstName;

  String get lastName => _lastName;

  UserSubscription? get userSubscription => _userSubscription;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isEmailVerified: json['is_email_verified'],
      userSubscription: json['user_subscription'] != null
          ? UserSubscription.fromJson(json['user_subscription'])
          : null,
    );
  }

  bool canViewPrediction(Prediction prediction) {
    Product predictionProduct = prediction.product;
    return hasAccessToProduct(predictionProduct.name);
  }

  bool hasAccessToProduct(ProductName productName) {
    if (userSubscription == null || !hasActiveSubscription()) {
      return false;
    }

    return _userSubscription!.products.any((p) => p.name == productName);
  }

  bool hasActiveSubscription() {
    if (_userSubscription == null) {
      return false;
    }
    return _userSubscription.status == SubscriptionStatus.ACTIVE;
  }

  String get fullName => '$_firstName $_lastName';
}
