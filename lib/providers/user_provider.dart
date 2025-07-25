import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/user.dart';
import '../service/dio_client.dart';

class UserProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final Logger logger = Logger();

  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isGuest = false;
  String? _userTimezone;
  ProductName? _selectedProductName;

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isInitialized => _isInitialized;

  bool get isAuthenticated => _user != null;

  bool get isGuest => _isGuest;

  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  bool hasAccessToProduct(ProductName productName) {
    if (_user == null) {
      return false;
    }

    return _user!.hasAccessToProduct(productName);
  }

  String? get userTimezone => _userTimezone;

  UserSubscription? get userSubscription => _user?.userSubscription;

  bool canViewPrediction(Prediction prediction) {
    if (prediction.status != PredictionStatus.PENDING) {
      return true;
    }

    return _user?.canViewPrediction(prediction) ?? false;
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

  Future<void> initialize() async {
    logger.i('Initializing user provider');
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken != null) {
        await getUserDetails();
        await _setInitialTimezone();
        await _restoreSelectedProductName();
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

  Future<void> logout() async {
    logger.i('Logging out user');
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'userTimezone');
    await _storage.delete(key: 'selectedProductName');
    _user = null;
    _userTimezone = null;
    _selectedProductName = null;
    notifyListeners();
  }

  Future<void> _setInitialTimezone() async {
    _userTimezone = await _storage.read(key: 'userTimezone');
    if (_userTimezone == null) {
      // Get the device's current timezone
      final localLocation = tz.local;
      _userTimezone = localLocation.name;
      await _storage.write(key: 'userTimezone', value: _userTimezone);
    }
    notifyListeners();
  }

  Future<void> setUserTimezone(String timezone) async {
    _userTimezone = timezone;
    await _storage.write(key: 'userTimezone', value: timezone);
    notifyListeners();
  }

  Future<void> _restoreSelectedProductName() async {
    final stored = await _storage.read(key: 'selectedProductName');
    if (stored != null) {
      try {
        _selectedProductName = ProductName.values.firstWhere((e) => e.name == stored);
      } catch (_) {
        _selectedProductName = null;
      }
    }
    notifyListeners();
  }

  // Add this public method for guests
  Future<void> setInitialTimezoneForGuest() async {
    await _setInitialTimezone();
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
