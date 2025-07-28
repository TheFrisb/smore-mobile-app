import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/match_prediction/match_prediction.dart';
import 'package:smore_mobile_app/components/tickets/ticket_prediction.dart';
import 'package:smore_mobile_app/providers/history_predictions_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

import '../../models/prediction_response.dart';

class HistoryPredictionsList extends StatefulWidget {
  const HistoryPredictionsList({
    super.key,
  });

  @override
  State<HistoryPredictionsList> createState() => _HistoryPredictionsListState();
}

class _HistoryPredictionsListState extends State<HistoryPredictionsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final historyProvider =
        Provider.of<HistoryPredictionsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        !historyProvider.isFetchingHistoryPredictions &&
        historyProvider.hasMorePages) {
      // Eager fetching - don't show loading indicator
      historyProvider.loadMoreData(
        userProvider.selectedProductName,
        userProvider.predictionObjectFilter,
      );
    }
  }

  String _getEmptyMessage(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return 'No history predictions available';
      case PredictionObjectFilter.tickets:
        return 'No history parlays available';
      case null:
      default:
        return 'No history predictions available';
    }
  }

  String _getEmptySubMessage(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return 'Check back later for historical predictions!';
      case PredictionObjectFilter.tickets:
        return 'Check back later for historical parlays!';
      case null:
      default:
        return 'Check back later for historical content!';
    }
  }

  IconData _getEmptyIcon(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return Icons.history;
      case PredictionObjectFilter.tickets:
        return Icons.description_outlined;
      case null:
      default:
        return Icons.history;
    }
  }

  Widget _buildEmptyState(
      BuildContext context, PredictionObjectFilter? filter) {
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
    return Consumer2<HistoryPredictionsProvider, UserProvider>(
      builder: (context, historyProvider, userProvider, child) {
        if (historyProvider.isFetchingHistoryPredictions &&
            historyProvider.historyPredictions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (historyProvider.errorMessage != null) {
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
                    historyProvider.errorMessage!,
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

        final filter = userProvider.predictionObjectFilter;
        final filteredPredictions =
            historyProvider.getFilteredPredictions(filter);

        if (filteredPredictions.isEmpty) {
          return _buildEmptyState(context, filter);
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          children: [
            const SizedBox(height: 16),
            ...filteredPredictions.map((predictionResponse) {
              // Render tickets and predictions as they come in the list
              if (predictionResponse.objectType == ObjectType.ticket) {
                final ticket = predictionResponse.ticket;
                if (ticket == null) {
                  return const SizedBox.shrink(); // Skip null tickets
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TicketPrediction(
                    ticket: ticket,
                    key: ValueKey('history_ticket_${ticket.id}'),
                  ),
                );
              } else {
                final prediction = predictionResponse.prediction;
                if (prediction == null) {
                  return const SizedBox.shrink(); // Skip null predictions
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MatchPrediction(
                    prediction: prediction,
                    key: ValueKey('history_prediction_${prediction.id}'),
                  ),
                );
              }
            }),
            // Show loading indicator only when fetching more data and we already have data
            if (historyProvider.isFetchingHistoryPredictions &&
                historyProvider.historyPredictions.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
