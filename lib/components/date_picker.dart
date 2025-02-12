import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // make container rounded
        decoration: const BoxDecoration(
          color: Color(0xB50D151E),
        ),
        child: Column(
          children: [
            DatePicker(
              DateTime(2025, 1, 1),
              height: 90,
              initialSelectedDate: initialDate,
              selectionColor: const Color(0xFF00503B),
              selectedTextColor: Colors.white,
              onDateChange: onDateChanged,
              // Optional: Add these properties to better match the container
              dayTextStyle: const TextStyle(color: Colors.white70),
              monthTextStyle: const TextStyle(color: Colors.white70),
              dateTextStyle: const TextStyle(color: Colors.white70),
            ),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0BA5EC).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ));
  }
}
