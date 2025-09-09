// lib/screens/authenticated_user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/default_bottom_navigation_bar.dart';
import 'package:smore_mobile_app/providers/upcoming_predictions_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/ai_chat_screen.dart';
import 'package:smore_mobile_app/screens/history_screen.dart';
import 'package:smore_mobile_app/screens/home_screen.dart';

import '../../providers/history_predictions_provider.dart';

class AuthenticatedUserScreen extends StatefulWidget {
  const AuthenticatedUserScreen({super.key});

  @override
  State<AuthenticatedUserScreen> createState() =>
      _AuthenticatedUserScreenState();
}

class _AuthenticatedUserScreenState extends State<AuthenticatedUserScreen> {
  int _currentIndex = 0;

  void _changeScreenIndex(int index) {
    if (_currentIndex == 2 && index != 2) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final upcomingPredictionsProvider =
        Provider.of<UpcomingPredictionsProvider>(context, listen: false);
    final historyPredictionsProvider =
        Provider.of<HistoryPredictionsProvider>(context, listen: false);

    // Reset filters to ALL when navigating to home (0) or history (1) screens
    if (index == 0 || index == 1) {
      userProvider.setSelectedProductName(null); // Reset to ALL sports
      userProvider.setPredictionObjectFilter(null); // Reset to ALL objects
    }

    final selectedProduct = userProvider.selectedProductName;
    final selectedPredictionObjectFilter =
        userProvider.predictionObjectFilter;

    if (index == 0) {
      upcomingPredictionsProvider.fetchUpcomingPredictions(
          updateIsLoading: false);
    }

    if (index == 1) {
      historyPredictionsProvider.fetchPaginatedHistoryPredictions(
        selectedProduct,
        selectedPredictionObjectFilter,
        updateIsLoading: true,
        forceRefresh: true,
      );
    }

    setState(() => _currentIndex = index);
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigateToIndex: _changeScreenIndex),
          HistoryScreen(onNavigateToIndex: _changeScreenIndex),
          AiChatScreen(onNavigateToIndex: _changeScreenIndex),
        ],
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeScreenIndex,
      ),
    );
  }
}
