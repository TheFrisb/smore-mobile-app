import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/tabbed_plan_view.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ManagePlanScreen extends StatelessWidget {
  const ManagePlanScreen({super.key});

  static final Logger _logger = Logger();

  Future<void> _launchUrl(String url) async {
    Uri uriResource = Uri.parse(url);
    if (!await launchUrl(uriResource, mode: LaunchMode.externalApplication)) {
      _logger.e("Failed to launch url: $url");
    }
  }

  Widget _buildStripeSubscriptionMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enhanced icon container with better gradient and shadow
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.3),
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.payment_rounded,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            // Enhanced main title with gradient text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'Stripe Subscription',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // Enhanced subtitle
            const Text(
              'You are subscribed through Stripe',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFdbe4ed),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Enhanced description container with better styling
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D151E).withOpacity(0.8),
                    const Color(0xFF0D151E).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please manage your subscription from our website',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFdbe4ed),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      await _launchUrl(
                          'https://smoreltd.com/accounts/manage-plan/');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Visit Website',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackButtonScreen(
      padding: const EdgeInsets.only(left: 16, right: 16),
      title: "Manage Plan",
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final User? user = userProvider.user;
          final UserSubscription? userSubscription =
              userProvider.user?.userSubscription;
          if (user == null) {
            return const Center(
              child: Text(
                'No user data available. This is most likely a bug in the application. Please contact support.',
              ),
            );
          }

          if (userSubscription != null &&
              userSubscription.providerType ==
                  SubscriptionProviderType.STRIPE) {
            return _buildStripeSubscriptionMessage(context);
          }

          // Show tabbed interface for non-Stripe users
          return const TabbedPlanView();
        },
      ),
    );
  }
}
