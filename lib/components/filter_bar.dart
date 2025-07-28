import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const FilterBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterItem(context, 0, 'All', Icons.list),
          const SizedBox(width: 16),
          _buildFilterItem(context, 1, 'Predictions', Icons.grading),
          const SizedBox(width: 16),
          _buildFilterItem(context, 2, 'Parlays', Icons.description),
        ],
      ),
    );
  }

  Widget _buildFilterItem(BuildContext context, int index, String label, IconData icon) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                size: 20,
                color: isSelected 
                    ? Theme.of(context).primaryColor
                    : const Color(0xFFdbe4ed),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).primaryColor
                      : const Color(0xFFdbe4ed),
                  fontSize: 14,
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