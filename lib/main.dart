import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/providers/prediction_provider.dart';
import 'package:smore_mobile_app/providers/purchase_provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/auth_wrapper_screen.dart';
import 'package:smore_mobile_app/theme/app_theme.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
        ChangeNotifierProvider(
          create: (context) => PurchaseProvider(
              Provider.of<UserProvider>(context, listen: false)),
        ),
      ],
      child: const MyApp(),
    ),
  );
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

  @override
  void initState() {
    super.initState();
    // Set up the network status listener
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      print('Connectivity results: $results');
      if (results.contains(ConnectivityResult.none)) {
        // No internet connection
        _showSnackBar();
      } else {
        // Internet connection restored
        _hideSnackBar();
      }
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
