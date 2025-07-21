import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedProduct = Provider.of<UserProvider>(context, listen: false).selectedProductName;
      Provider.of<PredictionProvider>(context, listen: false)
          .fetchPredictions(selectedProduct);
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
                  .fetchPredictions(newProduct);
            },
          ),
          const BrandGradientLine(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: PredictionsList(),
            ),
          ),
        ],
      ),
      endDrawer: const SideDrawer(),
    );
  }
}
