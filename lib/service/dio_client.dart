// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../constants/constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio.options = BaseOptions(
      baseUrl: Constants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _dio.interceptors.addAll([
      _authInterceptor,
      _createErrorLoggingInterceptor(),
    ]);
  }

  final Interceptor _authInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await _instance._storage.read(key: 'accessToken');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      // Skip token refresh for both /auth/refresh and /auth/login/
      if (error.response?.statusCode == 401 &&
          error.requestOptions.path != '/auth/refresh' &&
          error.requestOptions.path != '/auth/login/') {
        try {
          final newToken = await _instance._refreshToken();
          final opts = error.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          final response = await _instance._dio.fetch(opts);
          return handler.resolve(response);
        } catch (e) {
          await _instance._storage.deleteAll();
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: 'Session expired. Please login again.',
          ));
        }
      }
      return handler.next(error);
    },
  );

  // Create error logging interceptor method
  Interceptor _createErrorLoggingInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        _logger.e(
          'Dio Error: ${error.requestOptions.method} ${error.requestOptions.path}',
          error: error,
          stackTrace: error.stackTrace,
        );

        // Log additional error details
        if (error.response != null) {
          _logger.e(
            'Response Status: ${error.response?.statusCode}',
            error: error.response?.data,
          );
        } else {
          _logger.e('Network Error: ${error.message}');
        }

        return handler.next(error);
      },
    );
  }

  Future<String> _refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) throw Exception('No refresh token available');

    final response = await _dio.post('/auth/refresh', data: {
      'refresh': refreshToken,
    });

    final newAccessToken = response.data['access'];
    await _storage.write(key: 'accessToken', value: newAccessToken);
    return newAccessToken;
  }

  Dio get dio => _dio;
}
