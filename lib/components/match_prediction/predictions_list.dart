// components/match_prediction/predictions_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';

import 'match_prediction.dart';

class PredictionsList extends StatelessWidget {

  const PredictionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<PredictionProvider>(
      builder: (context, predictionProvider, child) {
        if (predictionProvider.isLoadingUpcomingPredictions) {
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

            const SizedBox(height: 16),
            ...predictionProvider.predictions.map((prediction) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MatchPrediction(
                      prediction: prediction, key: ValueKey(prediction.id)),
                )),
          ],
        );
      },
    );
  }
}
