import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/components/default_app_bar.dart';
import 'package:smore_mobile_app/components/side_drawer.dart';

import '../components/coming_soon_card.dart';
import '../components/date_picker.dart';
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
        bottomNavigationBar: SizedBox(
          height: kBottomNavigationBarHeight + 4,
          child: Column(
            children: [
              Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0BA5EC).withOpacity(0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.1, 0.5, 0.9], // Wider visible section
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    label: 'Predictions',
                    icon: Icon(Icons.insights_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'AI Chat',
                    icon: Icon(Icons.chat_bubble_outline),
                  ),
                  BottomNavigationBarItem(
                      label: 'Odds Calculator',
                      icon: Icon(Icons.percent_outlined)),
                ],
                onTap: (index) {
                  _tabController.animateTo(index);
                },
              ),
            ],
          ),
        ));
  }
}
