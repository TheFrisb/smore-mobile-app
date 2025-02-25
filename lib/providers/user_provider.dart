import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/user.dart';
import '../service/dio_client.dart';

class UserProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final Logger logger = Logger();

  User? _user;
  bool _isLoading = false;
  String? _userTimezone;

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  String? get userTimezone => _userTimezone;

  Future<void> initialize() async {
    logger.i('Initializing user provider');
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken != null) {
        await getUserDetails();
        await _setInitialTimezone();
      }
    } catch (e) {
      logger.e('Error initializing user provider: $e');
      await logout();
    } finally {
      _isLoading = false;
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
    _user = null;
    _userTimezone = null;
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
