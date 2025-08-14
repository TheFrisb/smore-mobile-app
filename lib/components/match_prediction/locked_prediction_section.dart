import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../app_colors.dart';
import '../../providers/user_provider.dart';
import '../../screens/manage_plan_screen.dart';
import '../../service/revenuecat_service.dart';
import '../purchases/unlock_button.dart';

class LockedPredictionSection extends StatelessWidget {
  static final Logger logger = Logger();
  final int predictionId;

  const LockedPredictionSection({super.key, required this.predictionId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isGuest = userProvider.isGuest;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isGuest) ...[
          // Login button for anonymous users
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF14202D).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF1E3A5A).withOpacity(0.5),
              ),
            ),
            child: InkWell(
              onTap: () {
                userProvider.isGuest = false;
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Log In',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.arrowRight,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'to access all predictions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondary.shade100,
              fontSize: 12,
            ),
          ),
        ] else ...[
          // Subscribe button for logged in users
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF14202D).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF1E3A5A).withOpacity(0.5),
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManagePlanScreen(),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Subscribe',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.arrowRight,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'to access all predictions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondary.shade100,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: const Color(0xFF64748B).withOpacity(0.2),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: const Color(0xFF64748B).withOpacity(0.2),
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          UnlockButton(
              onSuccess: null,
              onError: null,
              objectId: predictionId,
              consumableIdentifier: ConsumableIdentifiers.singlePrediction),
          const SizedBox(height: 8),
          FutureBuilder<Package?>(
            future: RevenueCatService()
                .getConsumablePackage(ConsumableIdentifiers.singlePrediction),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final price = snapshot.data!.storeProduct.price;
                return RichText(
                  text: TextSpan(
                    text: 'this prediction for ',
                    style: TextStyle(
                      color: AppColors.secondary.shade100,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }
}
