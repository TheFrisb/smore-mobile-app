import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../service/dio_client.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient().dio;

    return BaseBackButtonScreen(
      title: "My Account",
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final User? user = userProvider.user;
          if (user == null) {
            return const Center(
                child: Text(
                    'No user data available. This is most likely a bug in the application. Please contact support.'));
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                // add border radius
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF0D151E),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_circle_outlined,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text("Username",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(user.username, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                // add border radius
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF0D151E),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text("Email",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(user.email, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                // add border radius
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF0D151E),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text("Full Name",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(user.fullName, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const BrandGradientLine(
                height: 2,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Text("Current plan",
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  const Spacer(),
                  Text("Manage Plan",
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              Row(
                children: [
                  Text("Expires in 30 days",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400))
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.sports_soccer_outlined,
                      color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  const Text("Soccer", style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  Text("\$69.99/month",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 32),
              const BrandGradientLine(
                height: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Show confirmation snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Password change instructions sent to your email'),
                        duration: const Duration(seconds: 5),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
