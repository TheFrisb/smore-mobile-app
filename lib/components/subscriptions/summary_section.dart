import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../models/product.dart';

class SummarySection extends StatelessWidget {
  final List<Product> selectedProducts;
  final bool isYearly;
  final VoidCallback onSubscribe;

  const SummarySection({
    super.key,
    required this.selectedProducts,
    required this.isYearly,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = selectedProducts.fold<double>(
        0, (sum, p) => sum + (isYearly ? p.yearlyPrice : p.monthlyPrice));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.shade900.withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: AppColors.secondary.shade400.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total ${isYearly ? 'yearly' : 'monthly'} price',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.primary.shade300),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24,
                        color: AppColors.secondary.shade400,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          ...selectedProducts.map((p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.name.name,
                      style: TextStyle(color: AppColors.primary.shade200),
                    ),
                    Text(
                        '\$${(isYearly ? p.yearlyPrice : p.monthlyPrice).toStringAsFixed(2)}',
                        style: TextStyle(color: AppColors.primary.shade200)),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedProducts.isEmpty ? null : onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary.shade400,
                disabledBackgroundColor: const Color(0xFF195A80),
                disabledForegroundColor: Colors.white.withOpacity(0.5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Subscribe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
