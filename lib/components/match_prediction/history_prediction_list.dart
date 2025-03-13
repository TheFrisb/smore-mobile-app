// components/match_prediction/history_prediction_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/match_prediction/history_match_prediction.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';

class HistoryPredictionsList extends StatefulWidget {
  final int activeTabIndex;
  final DateTime currentDate;

  const HistoryPredictionsList({
    super.key,
    required this.activeTabIndex,
    required this.currentDate,
  });

  @override
  State<HistoryPredictionsList> createState() => _HistoryPredictionsListState();
}

class _HistoryPredictionsListState extends State<HistoryPredictionsList> {
  final ScrollController _scrollController = ScrollController();
  bool _didFetch = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didFetch) {
      final provider = Provider.of<PredictionProvider>(context, listen: false);
      if (provider.dateGroups.isEmpty) {
        provider.fetchPaginatedPredictions();
      }
      _didFetch = true; // Prevents repeated fetches
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<PredictionProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        !provider.isLoading &&
        provider.hasNextPage) {
      provider.fetchPaginatedPredictions();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeTabIndex != 0) {
      return const SizedBox.shrink();
    }

    return Consumer<PredictionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.dateGroups.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        if (provider.dateGroups.isEmpty) {
          return const Center(child: Text('No predictions available'));
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          children: [
            ...provider.dateGroups.expand((group) => [
                  _buildDateHeader(context, group.date),
                  ...group.predictions.map((prediction) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: HistoryMatchPrediction(prediction: prediction),
                      )),
                  const SizedBox(height: 16),
                ]),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final formattedDate = DateFormat('EEEE d MMMM y').format(date);
    return Column(
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
      ],
    );
  }
}
