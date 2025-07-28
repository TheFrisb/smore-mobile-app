import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
                        Icon(LucideIcons.user,
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
                        Icon(LucideIcons.mail,
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
                        Icon(LucideIcons.userLock,
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
              ),
              const SizedBox(height: 16),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.triangleAlert,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Are you sure you want to delete your account? This action cannot be undone.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Delete',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    if (confirmed == true) {
                      try {
                        await UserService().deleteAccount();
                        if (context.mounted) {
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .logout();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account deleted successfully.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete account: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
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
