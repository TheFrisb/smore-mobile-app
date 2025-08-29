import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';
import 'package:smore_mobile_app/service/user_service.dart';
import 'package:smore_mobile_app/utils/revenuecat_logger.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/sport/ticket.dart';
import '../models/user.dart';
import '../service/dio_client.dart';

enum PredictionObjectFilter {
  predictions,
  tickets,
}

class UserProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final Logger logger = Logger();
  final RevenueCatLogger _revenueCatLogger = RevenueCatLogger();

  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isGuest = false;
  String? _userTimezone;
  ProductName? _selectedProductName;
  PredictionObjectFilter? _predictionObjectFilter;
  CustomerInfo? _customerInfo;

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isInitialized => _isInitialized;

  bool get isAuthenticated => _user != null;

  bool get isGuest => _isGuest;

  CustomerInfo? get customerInfo => _customerInfo;

  PredictionObjectFilter? get predictionObjectFilter => _predictionObjectFilter;

  updateCustomerInfo() async {
    try {
      logger.i('Updating customer info');
      _revenueCatLogger.logRevenueCatInfo(
        operation: 'update_customer_info',
        infoMessage: 'Starting customer info update',
      );

      _customerInfo = await Purchases.getCustomerInfo();

      _revenueCatLogger.logRevenueCatSuccess(
        operation: 'update_customer_info',
        additionalData: {
          'entitlementsCount': _customerInfo?.entitlements.active.length ?? 0,
          'activeEntitlements':
              _customerInfo?.entitlements.active.keys.toList() ?? [],
        },
      );

      notifyListeners();
    } catch (e, stackTrace) {
      logger.e('Error updating customer info: $e');
      _revenueCatLogger.logRevenueCatError(
        operation: 'update_customer_info',
        errorType: 'CUSTOMER_INFO_ERROR',
        errorMessage: 'Failed to update customer info: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  bool hasAccessToProduct(ProductName productName) {
    if (_user == null) {
      return false;
    }

    return _user!.hasAccessToProduct(productName) ||
        hasAccessToEntitlement(productName);
  }

  String? get userTimezone => _userTimezone;

  UserSubscription? get userSubscription => _user?.userSubscription;

  bool canViewPrediction(Prediction prediction) {
    if (prediction.status != PredictionStatus.PENDING) {
      return true;
    }

    return _user?.canViewPrediction(prediction) ?? false;
  }

  bool canViewTicket(Ticket ticket) {
    if (ticket.status != TicketStatus.PENDING) {
      return true;
    }

    return _user?.canViewTicket(ticket) ?? false;
  }

  ProductName? get selectedProductName => _selectedProductName;

  Future<void> setSelectedProductName(ProductName? productName) async {
    _selectedProductName = productName;
    if (productName != null) {
      await _storage.write(key: 'selectedProductName', value: productName.name);
    } else {
      await _storage.delete(key: 'selectedProductName');
    }
    notifyListeners();
  }

  Future<void> setPredictionObjectFilter(PredictionObjectFilter? filter) async {
    if (_predictionObjectFilter == filter) return;

    if (filter != null) {
      _predictionObjectFilter = filter;
      await _storage.write(key: 'predictionObjectFilter', value: filter.name);
    } else {
      _predictionObjectFilter = null;
      await _storage.delete(key: 'predictionObjectFilter');
    }

    notifyListeners();
  }

  Future<void> initialize() async {
    logger.i('Initializing user provider');
    _isLoading = true;
    notifyListeners();

    try {
      updateCustomerInfo();
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken != null) {
        await getUserDetails();
        await _setInitialTimezone();
        await _restoreSelectedProductName();
        await _restorePredictionObjectFilter();
      } else {
        // For guests or unauthenticated users, still restore preferences
        await _restoreSelectedProductName();
        await _restorePredictionObjectFilter();
      }
    } catch (e) {
      logger.e('Error initializing user provider: $e');
      await logout();
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    logger.i('Logging in user');
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dioClient.dio.post('/auth/login/', data: {
        'username': username,
        'password': password,
      });

      await _storage.write(key: 'accessToken', value: response.data['access']);
      await _storage.write(
          key: 'refreshToken', value: response.data['refresh']);
      await getUserDetails();
      await _setInitialTimezone();
      subscribeToFcmTopic();

      RevenueCatService().setUserId(_user!.id);
    } on DioException catch (e) {
      int? statusCode = e.response?.statusCode;
      logger.e(statusCode);

      if (statusCode == 401) {
        logger.e('Invalid credentials');
        throw 'Invalid credentials';
      } else {
        logger.e('Error logging in user: $e');
        throw _handleDioError(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(String idToken) async {
    logger.i('Signing in with Google');
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _dioClient.dio.post('/auth/google-receiver/', data: {
        'credentials': idToken,
      });

      await _storage.write(key: 'accessToken', value: response.data['access']);
      await _storage.write(
          key: 'refreshToken', value: response.data['refresh']);
      await getUserDetails();
      await _setInitialTimezone();
      subscribeToFcmTopic();

      RevenueCatService().setUserId(_user!.id);
    } on DioException catch (e) {
      int? statusCode = e.response?.statusCode;
      logger.e('Google sign in error: $statusCode');

      if (statusCode == 401) {
        logger.e('Invalid Google credentials');
        throw 'Invalid Google credentials';
      } else {
        logger.e('Error signing in with Google: $e');
        throw _handleDioError(e);
      }
    } catch (e) {
      logger.e('Error during Google sign in: $e');
      throw e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithApple(String idToken) async {
    logger.i('Signing in with Apple');
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _dioClient.dio.post('/auth/apple-receiver/', data: {
        'id_token': idToken, // Changed from 'credentials'
      });

      await _storage.write(key: 'accessToken', value: response.data['access']);
      await _storage.write(
          key: 'refreshToken', value: response.data['refresh']);
      await getUserDetails();
      await _setInitialTimezone();
      subscribeToFcmTopic();

      RevenueCatService().setUserId(_user!.id);
    } on DioException catch (e) {
      int? statusCode = e.response?.statusCode;
      logger.e('Apple sign in error: $statusCode');

      if (statusCode == 401) {
        logger.e('Invalid Apple credentials');
        throw 'Invalid Apple credentials';
      } else {
        logger.e('Error signing in with Apple: $e');
        throw _handleDioError(e);
      }
    } catch (e) {
      logger.e('Error during Apple sign in: $e');
      throw e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserDetails() async {
    try {
      logger.i('Getting user details');
      final response = await _dioClient.dio.get('/auth/me/');
      _user = User.fromJson(response.data);
      notifyListeners();
    } on DioException catch (e) {
      logger.e('Error getting user details: $e');
      throw _handleDioError(e);
    }
  }

  Future<void> subscribeToFcmTopic() async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic("ALL");
      await UserService().sendFcmTokenToBackend(
          await FirebaseMessaging.instance.getToken() ?? '');
    } catch (e) {
      logger.e('Error subscribing to FCM topic: $e');
    }
  }

  Future<void> logout() async {
    logger.i('Logging out user');
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'userTimezone');
    await _storage.delete(key: 'selectedProductName');
    await _storage.delete(key: 'predictionObjectFilter');

    await FirebaseMessaging.instance.unsubscribeFromTopic("ALL");

    _user = null;
    _userTimezone = null;
    _selectedProductName = null;
    _predictionObjectFilter = null;
    _isGuest = false;
    notifyListeners();
  }

  Future<void> _setInitialTimezone() async {
    try {
      _userTimezone = await _storage.read(key: 'userTimezone');
      if (_userTimezone == null) {
        // Get the device's current timezone
        final localLocation = tz.local;
        _userTimezone = localLocation.name;
        logger.i('Setting initial timezone to: $_userTimezone');
        await _storage.write(key: 'userTimezone', value: _userTimezone);
      } else {
        logger.i('Restored timezone from storage: $_userTimezone');
      }
    } catch (e) {
      logger.e('Error setting timezone: $e');
      // Fallback to UTC if there's an error
      _userTimezone = 'UTC';
      await _storage.write(key: 'userTimezone', value: _userTimezone);
    }
    notifyListeners();
  }

  Future<void> setUserTimezone(String timezone) async {
    try {
      _userTimezone = timezone;
      logger.i('Setting user timezone to: $timezone');
      await _storage.write(key: 'userTimezone', value: timezone);
      notifyListeners();
    } catch (e) {
      logger.e('Error setting user timezone: $e');
    }
  }

  // Helper method to convert UTC datetime to user's timezone
  DateTime convertToUserTimezone(DateTime utcDateTime) {
    if (_userTimezone == null) {
      logger.w('No user timezone set, returning UTC datetime as-is');
      return utcDateTime; // Return as-is if no timezone set
    }

    try {
      final userLocation = tz.getLocation(_userTimezone!);
      final convertedDateTime = tz.TZDateTime.from(utcDateTime, userLocation);
      logger.d(
          'Converted UTC datetime $utcDateTime to $_userTimezone: $convertedDateTime');
      return convertedDateTime;
    } catch (e) {
      logger.e('Error converting to user timezone $_userTimezone: $e');
      return utcDateTime; // Return as-is if conversion fails
    }
  }

  // Helper method to format datetime for display
  String formatDateTimeForDisplay(DateTime utcDateTime) {
    final localDateTime = convertToUserTimezone(utcDateTime);
    final formatted =
        '${localDateTime.day}/${localDateTime.month} ${localDateTime.hour}:${localDateTime.minute.toString().padLeft(2, '0')}';
    logger.d(
        'Formatted datetime: $utcDateTime -> $formatted (timezone: $_userTimezone)');
    return formatted;
  }

  // Helper method to format datetime for detailed display (with year)
  String formatDateTimeForDetailedDisplay(DateTime utcDateTime) {
    final localDateTime = convertToUserTimezone(utcDateTime);
    final formatted =
        '${localDateTime.year}-${localDateTime.month.toString().padLeft(2, '0')}-${localDateTime.day.toString().padLeft(2, '0')} ${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
    logger.d(
        'Formatted detailed datetime: $utcDateTime -> $formatted (timezone: $_userTimezone)');
    return formatted;
  }

  Future<void> _restoreSelectedProductName() async {
    final stored = await _storage.read(key: 'selectedProductName');
    if (stored != null) {
      try {
        _selectedProductName =
            ProductName.values.firstWhere((e) => e.name == stored);
      } catch (_) {
        _selectedProductName = null;
      }
    }
    notifyListeners();
  }

  Future<void> _restorePredictionObjectFilter() async {
    final stored = await _storage.read(key: 'predictionObjectFilter');
    if (stored != null) {
      try {
        _predictionObjectFilter =
            PredictionObjectFilter.values.firstWhere((e) => e.name == stored);
      } catch (_) {
        _predictionObjectFilter = null;
      }
    }
    notifyListeners();
  }

  // Add this public method for guests
  Future<void> setInitialTimezoneForGuest() async {
    await _setInitialTimezone();
  }

  bool hasAccessToEntitlement(ProductName productName) {
    if (_customerInfo == null) {
      return false;
    }

    String normalizedName = productName.name.toLowerCase().replaceAll(' ', '_');

    final entitlement = _customerInfo!.entitlements.active[normalizedName];

    return entitlement != null;
  }

  List<String> getActiveEntitlementNames() {
    if (customerInfo == null) return [];

    return customerInfo!.entitlements.active.keys
        .map((id) {
          if (!id.startsWith('monthly_') && !id.startsWith('yearly_')) {
            return null;
          }

          final parts = id.split('_');
          final periodKey = parts.first;
          final productKey = parts.sublist(1).join('_');

          String? productName;
          switch (productKey) {
            case 'soccer':
              productName = 'Soccer';
              break;
            case 'basketball':
              productName = 'Basketball';
              break;
            case 'ai_analyst':
              productName = 'AI Analyst';
              break;
            default:
              productName = null;
          }
          if (productName == null) return null;

          final periodName = periodKey == 'monthly' ? 'Monthly' : 'Yearly';

          return '$productName $periodName';
        })
        .whereType<String>() // drop any nulls
        .toList();
  }

  String _handleDioError(DioException e) {
    logger.e('Dio error: $e');
    switch (e.response?.statusCode) {
      case 400:
        return 'Invalid credentials';
      case 401:
        return 'Session expired. Please login again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return e.message ?? 'An error occurred';
    }
  }
}
