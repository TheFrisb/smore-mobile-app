import 'package:flutter/material.dart';
import 'package:smore_mobile_app/app_colors.dart';

class BillingToggle extends StatelessWidget {
  final bool isYearly;
  final ValueChanged<bool> onChanged;

  const BillingToggle({
    Key? key,
    required this.isYearly,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Monthly',
          style: TextStyle(
            fontWeight: !isYearly ? FontWeight.bold : FontWeight.normal,
            color: !isYearly
                ? Theme.of(context).primaryColor
                : AppColors.primary.shade400,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          trackColor: WidgetStateProperty.all(
              AppColors.primary.shade800.withOpacity(0.5)),
          trackOutlineColor: WidgetStateProperty.all(
              AppColors.primary.shade700.withOpacity(0.6)),
          thumbColor: WidgetStateProperty.all(AppColors.secondary),
          value: isYearly,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
        const SizedBox(width: 8),
        Text(
          'Annual',
          style: TextStyle(
            fontWeight: isYearly ? FontWeight.bold : FontWeight.normal,
            color: isYearly
                ? Theme.of(context).primaryColor
                : AppColors.primary.shade400,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Save 20%',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
