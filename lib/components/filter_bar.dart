import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ObjectFilterBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const ObjectFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width to make spacing responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterItem(context, 0, 'All', LucideIcons.list),
          SizedBox(width: isSmallScreen ? 4 : 16),
          _buildFilterItem(context, 1, 'Predictions', LucideIcons.listCheck),
          SizedBox(width: isSmallScreen ? 4 : 16),
          _buildFilterItem(context, 2, 'Parlays', LucideIcons.scrollText),
        ],
      ),
    );
  }

  Widget _buildFilterItem(
      BuildContext context, int index, String label, IconData icon) {
    final isSelected = selectedIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 12, horizontal: isSmallScreen ? 4 : 0),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 16 : 20,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : const Color(0xFFdbe4ed),
              ),
              SizedBox(width: isSmallScreen ? 4 : 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : const Color(0xFFdbe4ed),
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
