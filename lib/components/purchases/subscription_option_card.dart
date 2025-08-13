import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final Package offeringPackage;
  final bool isYearly;
  final bool isSelected;
  final bool isOwned;
  final VoidCallback onSelect;

  const SubscriptionOptionCard({
    super.key,
    required this.offeringPackage,
    required this.isYearly,
    required this.isSelected,
    required this.isOwned,
    required this.onSelect,
  });

  String get _title => isYearly ? 'Yearly' : 'Monthly';

  String get _subtitle {
    if (isYearly) {
      return '12 mo ● ${offeringPackage.storeProduct.priceString}';
    } else {
      return 'Flexible monthly access';
    }
  }

  double _getMonthlyPrice() {
    if (isYearly) {
      return offeringPackage.storeProduct.price / 12;
    } else {
      return offeringPackage.storeProduct.price;
    }
  }

  double _getSavings() {
    if (isYearly) {
      final monthlyPrice = offeringPackage.storeProduct.price / 12;
      final yearlyPrice = offeringPackage.storeProduct.price;
      return ((yearlyPrice - (monthlyPrice * 12)) / yearlyPrice * 100)
          .roundToDouble();
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
                      ? Icon(
                          Icons.check,
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
                  '\$${_getMonthlyPrice().toStringAsFixed(2)}/mo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            // Savings badge for yearly plan
            if (isYearly)
              Positioned(
                top: -32,
                right: -4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Save ${_getSavings().toStringAsFixed(2)}%',
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
                  child: Text(
                    'Current Plan',
                    style: const TextStyle(
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
