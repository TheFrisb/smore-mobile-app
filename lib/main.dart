import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smore_mobile_app/providers/history_predictions_provider.dart';
import 'package:smore_mobile_app/providers/upcoming_predictions_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/wrappers/auth_wrapper_screen.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';
import 'package:smore_mobile_app/theme/app_theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:smore_mobile_app/utils/revenuecat_logger.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  tz.initializeTimeZones();
  Logger logger = Logger();
  final RevenueCatLogger _revenueCatLogger = RevenueCatLogger();

  // Initialize RevenueCat before running the app
  try {
    await RevenueCatService().initialize();
    logger.i('RevenueCat initialized successfully');
    _revenueCatLogger.logRevenueCatSuccess(
      operation: 'app_initialization',
      additionalData: {'component': 'main.dart'},
    );
  } catch (e, stackTrace) {
    logger.e('Failed to initialize RevenueCat: $e');
    _revenueCatLogger.logRevenueCatError(
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

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  SnackBar? _currentSnackBar;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
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
  }

  void _setupRevenueCatListener() {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateCustomerInfo();
      _logger.i('Customer info updated successfully in context');
      
      // Log the customer info update
      final RevenueCatLogger _revenueCatLogger = RevenueCatLogger();
      _revenueCatLogger.logRevenueCatInfo(
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
