import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_notification.dart';
import 'dio_client.dart';

class UserNotificationService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserNotificationService() : _dioClient = DioClient();

  Future<List<UserNotification>> fetchNotifications() async {
    try {
      final response = await _dioClient.dio.get('/notifications/');
      final List<dynamic> data = response.data;
      return data.map((json) => UserNotification.fromJson(json)).toList();
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch notifications. Please try again.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['detail'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response!.data;
      }
      throw Exception(errorMessage);
    }
  }

  Future<UserNotification> markNotificationRead(int notificationId) async {
    try {
      final response = await _dioClient.dio.patch(
        '/notifications/$notificationId/mark-read/',
      );
      return UserNotification.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage =
          'Failed to mark notification as read. Please try again.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['detail'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response!.data;
      }
      throw Exception(errorMessage);
    }
  }

  Future<int> markAllNotificationsRead() async {
    try {
      final response =
          await _dioClient.dio.patch('/notifications/mark-all-read/');
      final data = response.data as Map<String, dynamic>;
      return data['updated_count'] as int;
    } on DioException catch (e) {
      String errorMessage =
          'Failed to mark all notifications as read. Please try again.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['detail'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response!.data;
      }
      throw Exception(errorMessage);
    }
  }
}
