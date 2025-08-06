import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/products/product_display_name.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/user_subscription.dart';
import '../providers/user_provider.dart';
import '../service/dio_client.dart';
import '../service/user_service.dart';
import 'manage_plan_screen.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  static final Logger log = Logger();

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getAvatarColor(String text) {
    // Generate a color based on the user's name
    final hash = text.codeUnits.fold(0, (a, b) => a + b);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.deepPurple,
      Colors.cyan,
    ];
    return colors[hash % colors.length].withOpacity(0.85);
  }

  @override
  Widget build(BuildContext context) {
    final dio = DioClient().dio;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF0D151E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BaseBackButtonScreen(
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

            // SAFER INITIALS LOGIC
            String initials;
            if (user.fullName.trim().isNotEmpty) {
              final parts = user.fullName
                  .trim()
                  .split(' ')
                  .where((e) => e.isNotEmpty)
                  .toList();
              if (parts.isNotEmpty) {
                initials = parts.map((e) => e[0]).take(2).join().toUpperCase();
              } else {
                initials = user.username.isNotEmpty
                    ? user.username
                        .substring(0, min(2, user.username.length))
                        .toUpperCase()
                    : '?';
              }
            } else if (user.username.isNotEmpty) {
              initials = user.username
                  .substring(0, min(2, user.username.length))
                  .toUpperCase();
            } else {
              initials = '?';
            }

            return FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: _getAvatarColor(user.username),
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '@${user.username}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFb0b8c1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LucideIcons.user,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Info cards
                    // Email card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.mail,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Email",
                                  style: TextStyle(
                                    color: Color(0xFFb0b8c1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Plan section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.18),
                          width: 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(LucideIcons.crown,
                                  color: Theme.of(context).primaryColor,
                                  size: 28),
                              const SizedBox(width: 10),
                              Text(
                                "Your Plan",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _build_plans_section(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Actions
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(LucideIcons.lock,
                                size: 20, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await UserService()
                                    .sendPasswordResetRequest(user.email);
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
                                MyAccountScreen.log.e(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'An unexpected error has occured. Please try again or contact support if the issue persists.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            label: const Text(
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
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(LucideIcons.logOut,
                                color: Colors.red, size: 20),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side:
                                  const BorderSide(color: Colors.red, width: 1),
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
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(LucideIcons.triangleAlert,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 48),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Delete Account',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                                                .onSurface
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
                                                    Navigator.of(context)
                                                        .pop(false),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.white)),
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
                                        content: Text(
                                            'Account deleted successfully.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to delete account: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            label: const Text(
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
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _build_plans_section(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    UserSubscription? userSubscription = userProvider.userSubscription;
    final activeEntitlements = userProvider.getActiveEntitlementNames();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (userSubscription != null && userSubscription.isActive) ...[
          Row(
            children: [
              const Text("Current plan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const Spacer(),
              InkResponse(
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
        ] else if (activeEntitlements.isNotEmpty) ...[
          // Show active entitlements from RevenueCat
          Row(
            children: [
              const Text("Active plans",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const Spacer(),
              InkResponse(
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
          const SizedBox(height: 16),
          for (String entitlement in activeEntitlements) ...[
            Row(
              children: [
                _buildEntitlementIcon(entitlement),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entitlement,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (entitlement != activeEntitlements.last) ...[
              const SizedBox(height: 12),
            ]
          ]
        ] else ...[
          // No active plan or entitlements
          Row(
            children: [
              const Text("No active plan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const Spacer(),
              InkResponse(
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

  Widget _buildEntitlementIcon(String entitlement) {
    IconData iconData;
    Color iconColor;

    if (entitlement.toLowerCase().contains('soccer')) {
      iconData = Icons.sports_soccer_outlined;
      iconColor = Theme.of(context).primaryColor;
    } else if (entitlement.toLowerCase().contains('basketball')) {
      iconData = Icons.sports_basketball_outlined;
      iconColor = Theme.of(context).primaryColor;
    } else if (entitlement.toLowerCase().contains('ai analyst')) {
      iconData = Icons.sports_football_outlined;
      iconColor = Theme.of(context).primaryColor;
    } else {
      iconData = LucideIcons.crown;
      iconColor = Theme.of(context).primaryColor;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 24,
    );
  }
}
