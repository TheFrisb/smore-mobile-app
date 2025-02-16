import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/components/app_bars/default_app_bar.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';

import '../components/coming_soon_card.dart';
import '../components/date_picker.dart';
import '../components/default_bottom_navigation_bar.dart';
import '../components/predictions_list.dart';

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
        appBar: DefaultAppBar(
          tabController: _tabController,
        ),
        body: Column(
          children: [
            CustomDatePicker(
              initialDate: _selectedDate,
              onDateChanged: (date) {
                setState(() {
                  HomeScreen.logger.i("Date changed to: $date");
                  _selectedDate = date;
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
                      activeTabIndex: 0,
                      selectedDate: _selectedDate,
                    ),
                    const Center(
                        child: ComingSoonCard(sportName: "Basketball")),
                    const Center(child: ComingSoonCard(sportName: "NFL")),
                  ],
                ),
              ),
            ),
          ],
        ),
        endDrawer: const SideDrawer(),
        bottomNavigationBar: const DefaultBottomNavigationBar());
  }
}
