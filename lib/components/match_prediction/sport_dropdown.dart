import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/utils/string_utils.dart';

import '../../app_colors.dart';

class ProductDropdown extends StatelessWidget {
  final ProductName? selectedProduct; // Changed to nullable
  final ValueChanged<ProductName?> onChanged; // Changed to accept ProductName?

  const ProductDropdown({
    super.key,
    required this.selectedProduct,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        DropdownButtonHideUnderline(
          child: DropdownButton2<ProductName?>(
            alignment: Alignment.bottomLeft,
            value: selectedProduct,
            onChanged: (ProductName? newValue) {
              onChanged(newValue); // Pass null or selected value directly
            },
            items: [
              // Add "All Sports" option with null value
              DropdownMenuItem<ProductName?>(
                value: null,
                child: Row(
                  children: [
                    Icon(
                      Icons.sports,
                      color: selectedProduct == null
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'All Sports',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedProduct == null
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Existing product items
              ...ProductName.values
                  .where((product) => product != ProductName.AI_ANALYST)
                  .map((product) => _buildDropdownMenuItem(context, product)),
            ],
            customButton: _buildSelectedDisplay(context),
            // buttonStyleData: ButtonStyleData(
            //   width: 300,
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16),
            //     color: const Color(0xFF1A394F),
            //     border: Border.all(color: Colors.grey.withOpacity(0.5)),
            //   ),
            // ),
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, -8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF19374D),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down),
              iconEnabledColor: Colors.white,
              iconSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSelectedDisplay(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF1A394F),
        border:
            Border.all(color: AppColors.secondary.shade500.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: selectedProduct == null
                ? Row(
                    children: [
                      Icon(
                        Icons.sports,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All Sports',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                : _buildItemContent(context, selectedProduct!,
                    isSelected: true),
          ),
          Icon(Icons.keyboard_arrow_down,
              color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  DropdownMenuItem<ProductName?> _buildDropdownMenuItem(
      BuildContext context, ProductName product) {
    return DropdownMenuItem<ProductName?>(
      value: product,
      enabled: product != ProductName.TENNIS,
      child: _buildItemContent(context, product),
    );
  }

  Widget _buildItemContent(BuildContext context, ProductName product,
      {bool isSelected = false}) {
    final isEnabled =
        product != ProductName.TENNIS && product != ProductName.NFL_NHL;
    Color color = isEnabled
        ? (product == selectedProduct || isSelected
            ? Theme.of(context).primaryColor
            : Colors.white)
        : Colors.white.withOpacity(0.5);

    if (product == ProductName.NFL_NHL) {
      return _buildNFLNHLNCAA(context, color: color);
    }

    return _buildSimpleProduct(context, product, color: color);
  }

  Widget _buildSimpleProduct(BuildContext context, ProductName product,
      {required Color color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          _getProductIcon(product.name),
          color: color,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          StringUtils.capitalize(product.name),
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        if (product == ProductName.TENNIS) ...[
          const SizedBox(width: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildNFLNHLNCAA(BuildContext context, {required Color color}) {
    return Row(
      children: [
        _buildIconText(Icons.sports_football_outlined, 'NFL', color),
        Text(',   ', style: TextStyle(color: color)),
        _buildIconText(Icons.sports_hockey_outlined, 'NHL', color),
        const SizedBox(width: 8),
        Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

  IconData _getProductIcon(String productName) {
    switch (productName) {
      case 'SOCCER':
        return Icons.sports_soccer;
      case 'BASKETBALL':
        return Icons.sports_basketball;
      case 'TENNIS':
        return Icons.sports_tennis;
      case 'NFL':
        return Icons.sports_football;
      case 'NHL':
        return Icons.sports_hockey;
      default:
        return Icons.error;
    }
  }
}
