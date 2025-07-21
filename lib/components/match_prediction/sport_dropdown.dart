import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/utils/string_utils.dart';

import '../../app_colors.dart';

// Rename ProductDropdown to SportSelectorBar and update all references
class SportSelectorBar extends StatefulWidget {
  final ProductName? selectedProduct;
  final ValueChanged<ProductName?> onChanged;

  const SportSelectorBar({
    super.key,
    required this.selectedProduct,
    required this.onChanged,
  });

  @override
  State<SportSelectorBar> createState() => _SportSelectorBarState();
}

class _SportSelectorBarState extends State<SportSelectorBar> with TickerProviderStateMixin {
  bool _isDropdownOpen = false;
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut,
    ));
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 1.0,
      upperBound: 1.15,
    );
    _iconScale = _iconController.drive(Tween<double>(begin: 1.0, end: 1.15));
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onDropdownStateChanged(bool isOpen) {
    setState(() {
      _isDropdownOpen = isOpen;
      if (isOpen) {
        _arrowController.forward();
        _iconController.forward();
      } else {
        _arrowController.reverse();
        _iconController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? const Color(0xFF1A394F),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF223B54), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<ProductName?>
        (
          isExpanded: true,
          alignment: Alignment.centerLeft,
          value: widget.selectedProduct,
          onChanged: (ProductName? newValue) {
            widget.onChanged(newValue);
          },
          customButton: _buildBarDisplay(context),
          items: [
            DropdownMenuItem<ProductName?>(
              value: null,
              child: Row(
                children: [
                  Icon(
                    Icons.sports,
                    color: widget.selectedProduct == null
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All Sports',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selectedProduct == null
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ...ProductName.values
                .where((product) => product != ProductName.AI_ANALYST)
                .map((product) => _buildDropdownMenuItem(context, product)),
          ],
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, 0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              color: const Color(0xFF223B54),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.18)),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected) || states.contains(WidgetState.hovered)) {
                return Theme.of(context).primaryColor.withOpacity(0.18);
              }
              return Colors.transparent;
            }),
          ),
          iconStyleData: const IconStyleData(
            icon: SizedBox.shrink(), // Hide default icon
          ),
          onMenuStateChange: _onDropdownStateChanged,
        ),
      ),
    );
  }

  Widget _buildBarDisplay(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ScaleTransition(
                scale: _iconScale,
                child: widget.selectedProduct == null
                    ? Icon(
                        Icons.sports,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      )
                    : Icon(
                        _getProductIcon(widget.selectedProduct!.name),
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.selectedProduct?.displayName ?? 'All Sports',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          RotationTransition(
            turns: _arrowAnimation,
            child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor, size: 28),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<ProductName?> _buildDropdownMenuItem(
      BuildContext context, ProductName product) {
    return DropdownMenuItem<ProductName?>(
      value: product,
      enabled: product != ProductName.TENNIS && product != ProductName.NFL_NHL,
      child: _buildItemContent(context, product),
    );
  }

  Widget _buildItemContent(BuildContext context, ProductName product,
      {bool isSelected = false}) {
    final isEnabled =
        product != ProductName.TENNIS && product != ProductName.NFL_NHL;
    Color color = isEnabled
        ? (product == widget.selectedProduct || isSelected
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
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        if (product == ProductName.TENNIS) ...[
          const SizedBox(width: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              fontWeight: FontWeight.w400,
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
