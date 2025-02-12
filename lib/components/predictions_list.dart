// predictions_list.dart
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/match_prediction.dart';

class PredictionsList extends StatelessWidget {
  final int activeTabIndex;
  final DateTime selectedDate;

  const PredictionsList({
    super.key,
    required this.activeTabIndex,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    if (activeTabIndex != 0) {
      // 0 is Soccer tab index
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        MatchPrediction(),
        SizedBox(height: 16),
        MatchPrediction(),
        SizedBox(height: 16),
        MatchPrediction(),
      ],
    );
  }
}
