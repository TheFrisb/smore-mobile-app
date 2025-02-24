// user_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../models/user.dart';
import '../service/dio_client.dart';

class UserProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final Logger logger = Logger();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  Future<void> initialize() async {
    logger.i('Initializing user provider');
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken != null) {
        await getUserDetails();
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
    _user = null;
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
