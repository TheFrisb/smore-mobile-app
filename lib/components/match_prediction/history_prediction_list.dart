import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/match_prediction/match_prediction.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';

import '../../models/product.dart';

class HistoryPredictionsList extends StatefulWidget {
  final ProductName? productName;

  const HistoryPredictionsList({
    super.key,
    required this.productName,
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
    final provider = Provider.of<PredictionProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        !provider.isLoadingHistoryPredictions &&
        provider.hasNextPage) {
      provider.fetchPaginatedPredictions(widget.productName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PredictionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingHistoryPredictions &&
            provider.dateGroups.isEmpty) {
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
                      child: MatchPrediction(
                          key: ValueKey(prediction.id),
                          prediction: prediction))),
                  const SizedBox(height: 16),
                ]),
            if (provider.isLoadingHistoryPredictions)
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
