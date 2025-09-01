import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

    // Check if we need to load more data after initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfContentFillsScreen();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HistoryPredictionsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfContentFillsScreen();
    });
  }

  void _checkIfContentFillsScreen() {
    if (!mounted || !_scrollController.hasClients) return;

    final historyProvider =
        Provider.of<HistoryPredictionsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // If content doesn't fill screen and we have more pages, load more
    if (_scrollController.position.maxScrollExtent <= 0 &&
        historyProvider.historyPredictions.isNotEmpty &&
        historyProvider.hasMorePages &&
        !historyProvider.isFetchingHistoryPredictions &&
        !historyProvider.isLoadingMore) {
      historyProvider.loadMoreData(
        userProvider.selectedProductName,
        userProvider.predictionObjectFilter,
      );
    }
  }

  void _onScroll() {
    final historyProvider =
        Provider.of<HistoryPredictionsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Don't proceed if already loading or no more pages
    if (historyProvider.isFetchingHistoryPredictions ||
        historyProvider.isLoadingMore ||
        !historyProvider.hasMorePages) {
      return;
    }

    final position = _scrollController.position;

    // Handle case where content doesn't fill screen
    if (position.maxScrollExtent <= 0) {
      // Content is too short, load more immediately if we have data
      if (historyProvider.historyPredictions.isNotEmpty) {
        historyProvider.loadMoreData(
          userProvider.selectedProductName,
          userProvider.predictionObjectFilter,
        );
      }
      return;
    }

    // Calculate dynamic threshold - trigger when user is close to bottom
    final threshold =
        position.maxScrollExtent - (position.viewportDimension * 0.5);

    if (position.pixels >= threshold) {
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
        return 'Check back later for historical content!';
    }
  }

  IconData _getEmptyIcon(PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return LucideIcons.listOrdered;
      case PredictionObjectFilter.tickets:
        return LucideIcons.scrollText;
      case null:
        return LucideIcons.list;
    }
  }

  Widget _buildFooterSection(HistoryPredictionsProvider historyProvider) {
    if (historyProvider.shouldShowLoadingAtBottom) {
      return _buildLoadingIndicator();
    }

    if (historyProvider.shouldShowEndMessage) {
      return _buildEndMessage();
    }

    if (historyProvider.shouldShowScrollHint) {
      return _buildScrollHint();
    }

    return const SizedBox(height: 20);
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(top: 8.0),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text(
            'Loading more...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFdbe4ed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndMessage() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(top: 8.0),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 24,
            color: Color(0xFF4a9eff),
          ),
          SizedBox(height: 8),
          Text(
            'End of results',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFdbe4ed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollHint() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 8.0),
      child: const Column(
        children: [
          Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF6b7280),
          ),
          Text(
            'Scroll for more',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6b7280),
            ),
          ),
        ],
      ),
    );
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
        final allPredictions = historyProvider.historyPredictions;

        if (allPredictions.isEmpty) {
          return _buildEmptyState(context, filter);
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          children: [
            const SizedBox(height: 16),
            ...allPredictions.map((predictionResponse) {
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
            // Always show footer section with appropriate state
            _buildFooterSection(historyProvider),
          ],
        );
      },
    );
  }
}
