import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/filter_bar.dart';
import 'package:smore_mobile_app/components/match_prediction/history_prediction_list.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';
import 'package:smore_mobile_app/providers/history_predictions_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

import '../components/decoration/brand_gradient_line.dart';
import '../components/match_prediction/sport_dropdown.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static final Logger logger = Logger();

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistoryPredictions(true);
    });
  }

  void _fetchHistoryPredictions(bool updateIsLoading) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final historyProvider =
        Provider.of<HistoryPredictionsProvider>(context, listen: false);

    final selectedProduct = userProvider.selectedProductName;
    final selectedPredictionObjectFilter = userProvider.predictionObjectFilter;

    historyProvider.fetchPaginatedHistoryPredictions(
      selectedProduct,
      selectedPredictionObjectFilter,
      updateIsLoading: updateIsLoading,
    );
  }

  int _getFilterIndex(PredictionObjectFilter? filter) {
    switch (filter) {
      case null:
        return 0; // All
      case PredictionObjectFilter.predictions:
        return 1; // Predictions
      case PredictionObjectFilter.tickets:
        return 2; // Parlays (Tickets)
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1e2f42),
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
          SportSelectorBar(
            selectedProduct: userProvider.selectedProductName,
            onChanged: (newProduct) {
              if (userProvider.selectedProductName == newProduct) return;
              userProvider.setSelectedProductName(newProduct);
              _fetchHistoryPredictions(true);
            },
          ),
          FilterBar(
            selectedIndex: _getFilterIndex(userProvider.predictionObjectFilter),
            onChanged: (index) {
              // Set the prediction object filter based on selected index
              PredictionObjectFilter? filter;

              switch (index) {
                case 0: // All
                  filter = null;
                  break;
                case 1: // Predictions
                  filter = PredictionObjectFilter.predictions;
                  break;
                case 2: // Parlays (Tickets)
                  filter = PredictionObjectFilter.tickets;
                  break;
              }

              userProvider.setPredictionObjectFilter(filter);
              _fetchHistoryPredictions(true);
            },
          ),
          const BrandGradientLine(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: HistoryPredictionsList(),
            ),
          ),
        ],
      ),
      endDrawer: const SideDrawer(),
    );
  }
}
