import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/match_prediction/history_prediction_list.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';
import 'package:smore_mobile_app/components/sport_tab_bar.dart';

import '../components/coming_soon_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static final Logger logger = Logger();

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    // no functionality yet..
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      HistoryScreen.logger.i("Tab changed to index: ${_tabController.index}");
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  HistoryPredictionsList(
                    activeTabIndex: _tabController.index,
                    currentDate: _currentDate,
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
