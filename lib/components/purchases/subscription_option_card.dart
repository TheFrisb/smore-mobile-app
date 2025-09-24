import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final Package offeringPackage;
  final bool isQuarterly;
  final bool isWeekly;
  final bool isSelected;
  final bool isOwned;
  final VoidCallback onSelect;
  final Package? weeklyPackage; // For savings calculation

  const SubscriptionOptionCard({
    super.key,
    required this.offeringPackage,
    required this.isQuarterly,
    required this.isWeekly,
    required this.isSelected,
    required this.isOwned,
    required this.onSelect,
    this.weeklyPackage,
  });

  String get _title {
    if (isQuarterly) return 'Three months';
    if (isWeekly) return 'Weekly';
    return 'Monthly';
  }

  String get _subtitle {
    if (isQuarterly) {
      final currency = offeringPackage.storeProduct.priceString
          .replaceAll(RegExp(r'[\d.,]'), '')
          .trim();
      final monthlyPrice = offeringPackage.storeProduct.price / 3;
      return '$currency${monthlyPrice.toStringAsFixed(2)}/mo';
    } else if (isWeekly) {
      return ''; // No subtitle for weekly plans
    } else {
      return 'Flexible monthly access';
    }
  }

  double _getMonthlyPrice() {
    if (isQuarterly) {
      return offeringPackage.storeProduct.price / 3;
    } else if (isWeekly) {
      return offeringPackage.storeProduct.price * 4;
    } else {
      return offeringPackage.storeProduct.price;
    }
  }

  double _getSavings() {
    // Show savings badge on monthly plan compared to weekly
    if (!isWeekly && !isQuarterly && weeklyPackage != null) {
      final weeklyPrice = weeklyPackage!.storeProduct.price;
      final monthlyPrice = offeringPackage.storeProduct.price;
      final weeklyMonthlyEquivalent = weeklyPrice * 4; // 4 weeks in a month
      return weeklyMonthlyEquivalent - monthlyPrice; // Return dollar amount saved
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                // Circle with checkmark
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_subtitle.isNotEmpty)
                        Text(
                          _subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                    ],
                  ),
                ),
                // Price
                Text(
                  isQuarterly
                      ? '\$${offeringPackage.storeProduct.price.toStringAsFixed(2)}/quarterly'
                      : isWeekly
                          ? '\$${offeringPackage.storeProduct.price.toStringAsFixed(2)}/week'
                          : '\$${_getMonthlyPrice().toStringAsFixed(2)}/mo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            // Savings badge for monthly plan (compared to weekly)
            if (!isWeekly && !isQuarterly && _getSavings() > 0)
              Positioned(
                top: -30,
                right: -4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Save \$${_getSavings().toStringAsFixed(2)}/month',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            // Owned badge
            if (isOwned)
              Positioned(
                top: -24,
                left: -4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Current Plan',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
