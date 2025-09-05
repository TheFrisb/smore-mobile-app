import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smore_mobile_app/firebase_options.dart';
import 'package:smore_mobile_app/providers/history_predictions_provider.dart';
import 'package:smore_mobile_app/providers/upcoming_predictions_provider.dart';
import 'package:smore_mobile_app/providers/user_notification_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/wrappers/auth_wrapper_screen.dart';
import 'package:smore_mobile_app/service/firebase/firebase_messaging_service.dart';
import 'package:smore_mobile_app/service/firebase/local_notifications_service.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';
import 'package:smore_mobile_app/theme/app_theme.dart';
import 'package:smore_mobile_app/utils/revenuecat_logger.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize timezone database
  tz.initializeTimeZones();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(
      localNotificationsService: localNotificationsService);

  Logger logger = Logger();
  final RevenueCatLogger revenueCatLogger = RevenueCatLogger();

  // Initialize RevenueCat before running the app
  try {
    await RevenueCatService().initialize();
    logger.i('RevenueCat initialized successfully');
    revenueCatLogger.logRevenueCatSuccess(
      operation: 'app_initialization',
      additionalData: {'component': 'main.dart'},
    );
  } catch (e, stackTrace) {
    logger.e('Failed to initialize RevenueCat: $e');
    revenueCatLogger.logRevenueCatError(
      operation: 'app_initialization',
      errorType: 'INITIALIZATION_ERROR',
      errorMessage: 'Failed to initialize RevenueCat: ${e.toString()}',
      originalError: e,
      stackTrace: stackTrace,
    );
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((onValue) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()..initialize()),
            ChangeNotifierProvider(
                create: (_) => UpcomingPredictionsProvider()),
            ChangeNotifierProvider(create: (_) => HistoryPredictionsProvider()),
            ChangeNotifierProvider(
                create: (_) => UserNotificationProvider()..initialize()),
          ],
          child: const MyApp(),
        ),
      ));

  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  SnackBar? _currentSnackBar;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final Logger _logger = Logger();
  Timer? _periodicRefreshTimer;

  @override
  void initState() {
    super.initState();
    
    // Add app lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    
    // Set up the network status listener
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        // No internet connection
        _showSnackBar();
      } else {
        // Internet connection restored
        _hideSnackBar();
      }
    });

    _setupRevenueCatListener();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    // Remove app lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    _periodicRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        _logger.i('App became active - performing background refresh');
        _performBackgroundRefresh();
        _startPeriodicRefresh();
        break;
      case AppLifecycleState.paused:
        _logger.i('App went to background - stopping periodic updates');
        _stopPeriodicRefresh();
        break;
      case AppLifecycleState.detached:
        _logger.i('App detached - stopping periodic updates');
        _stopPeriodicRefresh();
        break;
      case AppLifecycleState.inactive:
        // App is transitioning between states
        break;
      case AppLifecycleState.hidden:
        // App is hidden but still running
        break;
    }
  }

  /// Start periodic refresh timer
  void _startPeriodicRefresh() {
    _stopPeriodicRefresh(); // Stop any existing timer
    
    _logger.i('Starting periodic refresh - Upcoming: 5min, Notifications: 10min');
    
    // Refresh upcoming predictions every 5 minutes
    _periodicRefreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _performPeriodicRefresh(),
    );
  }

  /// Stop periodic refresh timer
  void _stopPeriodicRefresh() {
    _periodicRefreshTimer?.cancel();
    _periodicRefreshTimer = null;
  }

  /// Perform periodic refresh of data
  Future<void> _performPeriodicRefresh() async {
    try {
      _logger.d('Performing periodic refresh');
      
      final upcomingProvider = Provider.of<UpcomingPredictionsProvider>(context, listen: false);
      final notificationProvider = Provider.of<UserNotificationProvider>(context, listen: false);
      
      // Refresh upcoming predictions
      await upcomingProvider.fetchUpcomingPredictions(updateIsLoading: false);
      
      // Refresh notifications every 10 minutes (every 2nd call)
      final now = DateTime.now();
      if (now.minute % 10 == 0) {
        await notificationProvider.refresh();
      }
      
      _logger.d('Periodic refresh completed successfully');
    } catch (e) {
      _logger.e('Error during periodic refresh: $e');
    }
  }

  /// Perform background refresh when app becomes active
  Future<void> _performBackgroundRefresh() async {
    try {
      final upcomingProvider = Provider.of<UpcomingPredictionsProvider>(context, listen: false);
      final notificationProvider = Provider.of<UserNotificationProvider>(context, listen: false);
      
      _logger.i('Refreshing data in background (app became active)');
      
      // Refresh upcoming predictions
      await upcomingProvider.fetchUpcomingPredictions(updateIsLoading: false);
      
      // Refresh notifications
      await notificationProvider.refresh();
      
      _logger.i('Background refresh completed successfully');
    } catch (e) {
      _logger.e('Error during background refresh: $e');
    }
  }

  void _setupRevenueCatListener() {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateCustomerInfo();
      _logger.i('Customer info updated successfully in context');

      // Log the customer info update
      final RevenueCatLogger revenueCatLogger = RevenueCatLogger();
      revenueCatLogger.logRevenueCatInfo(
        operation: 'customer_info_listener',
        infoMessage: 'Customer info updated via listener',
        additionalData: {
          'entitlementsCount': customerInfo.entitlements.active.length,
          'activeEntitlements': customerInfo.entitlements.active.keys.toList(),
        },
      );
    });
  }

  void _showSnackBar() {
    _currentSnackBar = const SnackBar(
      content: Text('No internet connection. Please check your settings.'),
      duration: Duration(days: 1), // Persistent until hidden
      backgroundColor: Colors.redAccent, // Optional: enhance visibility
    );
    _scaffoldMessengerKey.currentState?.showSnackBar(_currentSnackBar!);
  }

  void _hideSnackBar() {
    if (_currentSnackBar != null) {
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _currentSnackBar = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      // Attach the GlobalKey here
      debugShowCheckedModeBanner: false,
      title: 'SMORE\'s Mobile Application',
      theme: AppTheme.dark,
      home: const AuthWrapperScreen(),
    );
  }
}
