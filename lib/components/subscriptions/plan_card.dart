import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';

import '../../app_colors.dart';
import '../../models/product.dart';

class PlanCard extends StatelessWidget {
  final Product product;
  final bool isYearly;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  const PlanCard({
    super.key,
    required this.product,
    required this.isYearly,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double priceToShow =
        isYearly ? product.yearlyPrice / 12 : product.monthlyPrice;

    // Define colors based on selection
    final LinearGradient bgGradient = isSelected
        ? LinearGradient(
            colors: [
              AppColors.secondary.shade500.withOpacity(0.2),
              AppColors.secondary.shade700.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [
              AppColors.primary.shade800.withOpacity(0.5),
              AppColors.primary.shade900.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    final Color borderColor =
        isSelected ? const Color(0xFF13618A) : const Color(0xFF165273);

    return Container(
      decoration: BoxDecoration(
        gradient: bgGradient, // Apply the gradient here
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow for elevation
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onSelected(!isSelected),
        borderRadius: BorderRadius.circular(16), // Match the container's radius
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(_getProductIcon(product.name.name),
                          color: AppColors.secondary, size: 32),
                      const SizedBox(width: 6),
                      Text(
                        product.name.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  _buildCustomCheckbox(isSelected),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isYearly) ...[
                    Text(
                      '\$${product.monthlyPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.primary.shade400,
                        color: AppColors.primary.shade400,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    '\$${priceToShow.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  if (product.type == ProductType.ADDON) ...[
                    const SizedBox(width: 8),
                    Text(
                      'per month',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary.shade300,
                      ),
                    ),
                  ]
                ],
              ),
              if (product.type == ProductType.SUBSCRIPTION) ...[
                const SizedBox(height: 4),
                Text(
                  'per month',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary.shade300,
                  ),
                ),
                const SizedBox(height: 16),
                const BrandGradientLine(
                  height: 1,
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                    '${product.analysesPerMonth} analyses per month'),
                _buildFeatureItem('High Odds'),
                _buildFeatureItem('Betting Guidance'),
                _buildFeatureItem('Promotions & Giveaways'),
                _buildFeatureItem('24/7 Client Support'),
                _buildFeatureItem('Affiliate program'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getProductIcon(String name) {
    switch (name) {
      case 'Soccer':
        return Icons.sports_soccer;
      case 'AI Analyst':
        return Icons.analytics_outlined;
      case 'Tennis':
        return Icons.sports_tennis;

      default:
        return Icons.sports_soccer;
    }
  }

  Widget _buildCustomCheckbox(bool isSelected) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
        width: 28, // Larger size
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.primary.shade500 : Colors.transparent,
          border: Border.all(
            color: AppColors.primary.shade500,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_outlined,
            color: AppColors.secondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
