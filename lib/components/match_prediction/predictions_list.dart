// components/match_prediction/predictions_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/tickets/ticket_prediction.dart';
import 'package:smore_mobile_app/providers/upcoming_predictions_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

import 'match_prediction.dart';

class PredictionsList extends StatelessWidget {
  const PredictionsList({
    super.key,
  });

  String _getEmptyMessage(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return 'No predictions available';
      case PredictionObjectFilter.tickets:
        return 'No parlays available';
      case null:
      default:
        return 'No predictions available';
    }
  }

  String _getEmptySubMessage(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return 'Check back later for new predictions!';
      case PredictionObjectFilter.tickets:
        return 'Check back later for new parlays!';
      case null:
      default:
        return 'Check back later for new content!';
    }
  }

  IconData _getEmptyIcon(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return Icons.grading_outlined;
      case PredictionObjectFilter.tickets:
        return Icons.description_outlined;
      case null:
      default:
        return Icons.inbox_outlined;
    }
  }

  Widget _buildEmptyState(BuildContext context, PredictionObjectFilter? filter) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                _getEmptyIcon(filter),
                size: 40,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getEmptyMessage(filter),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubMessage(filter),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFdbe4ed),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UpcomingPredictionsProvider, UserProvider>(
      builder: (context, predictionProvider, userProvider, child) {
        if (predictionProvider.isFetchingUpcomingPredictions) {
          return const Center(child: CircularProgressIndicator());
        }

        if (predictionProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    predictionProvider.errorMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFdbe4ed),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final tickets = predictionProvider.orderedUpcomingTicketsOnly;
        final predictions = predictionProvider.orderedUpcomingPredictionsOnly;
        final filter = userProvider.predictionObjectFilter;

        // Check if empty based on filter
        bool isEmpty = false;
        switch (filter) {
          case PredictionObjectFilter.predictions:
            isEmpty = predictions.isEmpty;
            break;
          case PredictionObjectFilter.tickets:
            isEmpty = tickets.isEmpty;
            break;
          case null:
          default:
            isEmpty = tickets.isEmpty && predictions.isEmpty;
            break;
        }

        if (isEmpty) {
          return _buildEmptyState(context, filter);
        }

        // Filter content based on selection
        List<Widget> content = [];
        
        switch (filter) {
          case PredictionObjectFilter.predictions:
            // Show only predictions
            content.addAll(predictions.map((prediction) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MatchPrediction(
                      prediction: prediction, key: ValueKey('prediction_${prediction.id}')),
                )));
            break;
          case PredictionObjectFilter.tickets:
            // Show only tickets
            content.addAll(tickets.map((ticket) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TicketPrediction(
                      ticket: ticket, key: ValueKey('ticket_${ticket.id}')),
                )));
            break;
          case null:
          default:
            // Show both tickets first, then predictions
            content.addAll(tickets.map((ticket) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TicketPrediction(
                      ticket: ticket, key: ValueKey('ticket_${ticket.id}')),
                )));
            content.addAll(predictions.map((prediction) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MatchPrediction(
                      prediction: prediction, key: ValueKey('prediction_${prediction.id}')),
                )));
            break;
        }

        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            const SizedBox(height: 16),
            ...content,
          ],
        );
      },
    );
  }
}
