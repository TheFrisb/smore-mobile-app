import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/components/purchases/unlock_button.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';

import '../app_colors.dart';

class DailyOffer extends StatelessWidget {
  const DailyOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.secondary.shade500.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background gradient
              Container(
                color: const Color(0xFF0D151E),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title with diamond icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.gem,
                          color: AppColors.secondary.shade400,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'All Picks for Today',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Description text
                    Text(
                      'Exclusive access to today\'s parlays & predictions',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Price
                    Text(
                      '\$24.99',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary.shade400,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const UnlockButton(
                        onSuccess: null,
                        onError: null,
                        objectId: 0,
                        consumableIdentifier: ConsumableIdentifiers.dailyOffer)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
