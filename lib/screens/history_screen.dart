import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/match_prediction/history_prediction_list.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';

import '../components/decoration/brand_gradient_line.dart';
import '../components/match_prediction/sport_dropdown.dart';
import '../models/product.dart';
import '../providers/prediction_provider.dart';
import '../providers/user_provider.dart';

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
      final selectedProduct = Provider.of<UserProvider>(context, listen: false).selectedProductName;
      Provider.of<PredictionProvider>(context, listen: false)
          .fetchPaginatedPredictions(selectedProduct);
    });
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
              Provider.of<PredictionProvider>(context, listen: false)
                  .fetchPaginatedPredictions(newProduct);
            },
          ),
          const BrandGradientLine(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: HistoryPredictionsList(productName: userProvider.selectedProductName),
            ),
          ),
        ],
      ),
      endDrawer: const SideDrawer(),
    );
  }
}
