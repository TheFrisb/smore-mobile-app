import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/match_prediction/history_prediction_list.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';

import '../components/match_prediction/sport_dropdown.dart';
import '../models/product.dart';
import '../providers/prediction_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static final Logger logger = Logger();

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DateTime _currentDate = DateTime.now();
  ProductName? _selectedProductName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e2f42),
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
          Center(
            child: ProductDropdown(
              selectedProduct: _selectedProductName,
              onChanged: (newProduct) {
                setState(() {
                  _selectedProductName = newProduct;
                  Provider.of<PredictionProvider>(context, listen: false)
                      .fetchPaginatedPredictions(_selectedProductName);
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: HistoryPredictionsList(productName: _selectedProductName),
            ),
          ),
        ],
      ),
      endDrawer: const SideDrawer(),
    );
  }
}
