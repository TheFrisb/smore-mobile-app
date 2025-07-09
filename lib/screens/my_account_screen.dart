import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/products/product_display_name.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/user_subscription.dart';
import '../providers/user_provider.dart';
import '../service/dio_client.dart';
import '../service/user_service.dart';
import 'manage_plan_screen.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  static final Logger log = Logger();

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
                    'No user data available. Please check your internet connection.'));
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                // add border radius
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(16),
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
              // const SizedBox(height: 32),
              // const BrandGradientLine(
              //   height: 2,
              // ),
              // const SizedBox(height: 32),
              // _build_plans_section(context),
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await UserService().sendPasswordResetRequest(user.email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Password change instructions sent to your email'),
                          duration: const Duration(seconds: 5),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    } catch (e) {
                      log.e(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'An unexpected error has occured. Please try again or contact support if the issue persists.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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

  Widget _build_plans_section(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    UserSubscription? userSubscription = userProvider.userSubscription;

    return Column(
      children: [
        if (userSubscription != null && userSubscription.isActive) ...[
          Row(
            children: [
              const Text("Current plan",
                  style: TextStyle(
                    fontSize: 18,
                  )),
              const Spacer(),
              // tapable text
              InkResponse(
                // on tap navigate to subscription screen
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManagePlanScreen()));
                },
                child: Text("Manage Plan",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              )
            ],
          ),
          Row(
            children: [
              Text(
                  "Expires on ${DateFormat('dd MMM yyyy').format(userSubscription.endDate)}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400))
            ],
          ),
          const SizedBox(height: 24),
          for (Product product in userSubscription.products) ...[
            Row(
              children: [
                ProductDisplayName(product: product),
                const Spacer(),
                Text(
                    "\$${userSubscription.getProductSalePrice(product)}/${userSubscription.frequency.nounDisplayName}",
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              ],
            ),
            if (product != userSubscription.products.last) ...[
              const SizedBox(height: 12),
            ]
          ]
        ] else ...[
          Row(
            children: [
              const Text("No active plan",
                  style: TextStyle(
                    fontSize: 18,
                  )),
              const Spacer(),
              InkResponse(
                // on tap navigate to subscription screen
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManagePlanScreen()));
                },
                child: Text("View Plans",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              )
            ],
          ),
        ]
      ],
    );
  }
}
