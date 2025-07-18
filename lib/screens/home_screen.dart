import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';

import '../components/date_picker.dart';
import '../components/match_prediction/predictions_list.dart';
import '../components/match_prediction/sport_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final Logger logger = Logger();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  ProductName? _selectedProductName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PredictionProvider>(context, listen: false)
          .fetchPredictions(_selectedDate, _selectedProductName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e2f42),
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
          CustomDatePicker(
            initialDate: _selectedDate,
            onDateChanged: (date) {
              setState(() {
                HomeScreen.logger.i("Date changed to: $date");
                _selectedDate = date;
                Provider.of<PredictionProvider>(context, listen: false)
                    .fetchPredictions(_selectedDate, _selectedProductName);
              });
            },
          ),
          Center(
            child: ProductDropdown(
              selectedProduct: _selectedProductName,
              onChanged: (newProduct) {
                if (_selectedProductName == newProduct) return;
                
                setState(() {
                  _selectedProductName = newProduct;
                  Provider.of<PredictionProvider>(context, listen: false)
                      .fetchPredictions(_selectedDate, newProduct);
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PredictionsList(selectedDate: _selectedDate),
            ),
          ),
        ],
      ),
      endDrawer: const SideDrawer(),
    );
  }
}
