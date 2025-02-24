import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';
import 'package:smore_mobile_app/components/sport_tab_bar.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';

import '../components/coming_soon_card.dart';
import '../components/date_picker.dart';
import '../components/match_prediction/predictions_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final Logger logger = Logger();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Fetch initial predictions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PredictionProvider>(context, listen: false)
          .fetchPredictions(_selectedDate);
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      HomeScreen.logger.i("Tab changed to index: ${_tabController.index}");
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e2f42),
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
          SportTabBar(tabController: _tabController),
          CustomDatePicker(
            initialDate: _selectedDate,
            onDateChanged: (date) {
              setState(() {
                HomeScreen.logger.i("Date changed to: $date");
                _selectedDate = date;
                Provider.of<PredictionProvider>(context, listen: false)
                    .fetchPredictions(date);
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  PredictionsList(
                    activeTabIndex: _tabController.index,
                    selectedDate: _selectedDate,
                  ),
                  const Center(child: ComingSoonCard(sportName: "Basketball")),
                  const Center(child: ComingSoonCard(sportName: "NFL")),
                ],
              ),
            ),
          ),
        ],
      ),
      endDrawer: const SideDrawer(),
    );
  }
}
