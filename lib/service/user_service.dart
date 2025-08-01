import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dio_client.dart';

class UserService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserService() : _dioClient = DioClient();

  Future<void> sendPasswordResetRequest(String email) async {
    try {
      await _dioClient.dio.post(
        '/auth/password-reset/',
        data: {'email': email},
      );
    } on DioException catch (e) {
      String errorMessage =
          'Failed to send reset instructions. Please try again.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['detail'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response!.data;
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dioClient.dio.delete('/accounts/delete/');

      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'accessToken');

    } on DioException catch (e) {
      String errorMessage = 'Failed to delete account. Please try again.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['detail'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response!.data;
      }
      throw Exception(errorMessage);
    }
  }
}
