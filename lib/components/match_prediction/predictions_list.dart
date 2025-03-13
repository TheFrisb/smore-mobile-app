// components/match_prediction/predictions_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';

import 'match_prediction.dart';

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

    final formattedDate = DateFormat('EEEE d MMMM y').format(selectedDate);

    return Consumer<PredictionProvider>(
      builder: (context, predictionProvider, child) {
        if (predictionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (predictionProvider.error != null) {
          return Center(child: Text(predictionProvider.error!));
        }

        if (predictionProvider.predictions.isEmpty) {
          return const Center(child: Text('No predictions available'));
        }

        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFFDBE4ED),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...predictionProvider.predictions.map((prediction) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MatchPrediction(prediction: prediction),
                )),
          ],
        );
      },
    );
  }
}
