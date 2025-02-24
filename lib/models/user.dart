// user.dart
import 'package:smore_mobile_app/models/user_subscription.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool isEmailVerified;
  final UserSubscription? userSubscription;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isEmailVerified,
    required this.firstName,
    required this.lastName,
    this.userSubscription,
  });

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

  String get fullName => '$firstName $lastName';
}
