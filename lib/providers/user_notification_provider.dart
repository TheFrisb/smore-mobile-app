import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/components/notification_item.dart';
import 'package:smore_mobile_app/models/user_notification.dart';
import 'package:smore_mobile_app/service/user_notifications_service.dart';

class UserNotificationProvider with ChangeNotifier {
  static final Logger logger = Logger();
  final UserNotificationService _notificationService =
      UserNotificationService();

  List<UserNotification> _notifications = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  // Getters
  List<UserNotification> get notifications => _notifications;

  bool get isLoading => _isLoading;

  bool get isInitialized => _isInitialized;

  String? get error => _error;

  // Computed getters
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<UserNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  // Group notifications by date (most recent first)
  Map<String, List<UserNotification>> get groupedNotifications {
    final Map<String, List<UserNotification>> grouped = {};

    for (var notification in _notifications) {
      final dateKey = _formatDateKey(notification.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    // Sort notifications within each group by creation time (newest first)
    for (var notifications in grouped.values) {
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return grouped;
  }

  // Get sorted date keys (most recent first)
  List<String> get sortedDateKeys {
    final keys = groupedNotifications.keys.toList();
    keys.sort((a, b) => b.compareTo(a)); // Sort dates in descending order
    return keys;
  }

  // Get important notifications from today
  List<UserNotification> get importantNotificationsToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      return notification.isImportant && notificationDate == today;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by creation time, newest first
  }

  // Get normal notifications (excluding important ones from today)
  List<UserNotification> get normalNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      // Include if not important, or if important but not from today
      return !notification.isImportant || notificationDate != today;
    }).toList();
  }

  // Group normal notifications by date (most recent first)
  Map<String, List<UserNotification>> get groupedNormalNotifications {
    final Map<String, List<UserNotification>> grouped = {};

    for (var notification in normalNotifications) {
      final dateKey = _formatDateKey(notification.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    // Sort notifications within each group by creation time (newest first)
    for (var notifications in grouped.values) {
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return grouped;
  }

  // Get sorted date keys for normal notifications (most recent first)
  List<String> get sortedNormalDateKeys {
    final keys = groupedNormalNotifications.keys.toList();
    keys.sort((a, b) => b.compareTo(a)); // Sort dates in descending order
    return keys;
  }

  /// Initialize the provider and fetch notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    logger.i('Initializing UserNotificationProvider');
    await fetchNotifications();
    _isInitialized = true;
    notifyListeners();
  }

  /// Fetch notifications from the backend
  Future<void> fetchNotifications() async {
    logger.i('Fetching notifications from backend');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final notifications = await _notificationService.fetchNotifications();
      _notifications = notifications;
      logger.i('Successfully fetched ${notifications.length} notifications');
    } catch (e) {
      _error = e.toString();
      logger.e('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark a single notification as read (optimistically)
  Future<void> markNotificationAsRead(int notificationId) async {
    logger.i('Marking notification $notificationId as read');

    // Find the notification
    final notificationIndex =
        _notifications.indexWhere((n) => n.id == notificationId);
    if (notificationIndex == -1) {
      logger.w('Notification $notificationId not found');
      return;
    }

    final notification = _notifications[notificationIndex];
    if (notification.isRead) {
      logger.i('Notification $notificationId is already read');
      return;
    }

    // Optimistic update
    _notifications[notificationIndex] = UserNotification(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      isRead: true,
      isImportant: notification.isImportant,
      icon: notification.icon,
      createdAt: notification.createdAt,
    );
    notifyListeners();

    // Backend call
    try {
      await _notificationService.markNotificationRead(notificationId);
      logger.i(
          'Successfully marked notification $notificationId as read on backend');
    } catch (e) {
      // Revert optimistic update on error
      _notifications[notificationIndex] = notification;
      _error = 'Failed to mark notification as read';
      logger.e('Error marking notification $notificationId as read: $e');
      notifyListeners();
    }
  }

  /// Mark all notifications as read (optimistically)
  Future<void> markAllNotificationsAsRead() async {
    logger.i('Marking all notifications as read');

    final unreadNotifications = _notifications.where((n) => !n.isRead).toList();
    if (unreadNotifications.isEmpty) {
      logger.i('No unread notifications to mark');
      return;
    }

    // Store original state for potential rollback
    final originalNotifications = List<UserNotification>.from(_notifications);

    // Optimistic update
    _notifications = _notifications.map((notification) {
      if (!notification.isRead) {
        return UserNotification(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          isRead: true,
          isImportant: notification.isImportant,
          icon: notification.icon,
          createdAt: notification.createdAt,
        );
      }
      return notification;
    }).toList();
    notifyListeners();

    // Backend call
    try {
      final updatedCount =
          await _notificationService.markAllNotificationsRead();
      logger.i(
          'Successfully marked $updatedCount notifications as read on backend');
    } catch (e) {
      // Revert optimistic update on error
      _notifications = originalNotifications;
      _error = 'Failed to mark all notifications as read';
      logger.e('Error marking all notifications as read: $e');
      notifyListeners();
    }
  }

  /// Refresh notifications (useful for pull-to-refresh)
  Future<void> refresh() async {
    logger.i('Refreshing notifications');
    await fetchNotifications();
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get notifications for a specific date
  List<UserNotification> getNotificationsForDate(String dateKey) {
    return groupedNotifications[dateKey] ?? [];
  }

  /// Get normal notifications for a specific date
  List<UserNotification> getNormalNotificationsForDate(String dateKey) {
    return groupedNormalNotifications[dateKey] ?? [];
  }

  /// Format date key for grouping (YYYY-MM-DD format)
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get display date string (Today, Yesterday, or formatted date)
  String getDisplayDate(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day} ${_getMonthName(date.month)}';
    }
  }

  /// Get month name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  /// Get notification icon based on notification's icon field
  IconData getNotificationIcon(UserNotification notification) {
    return NotificationItem.getNotificationIcon(notification.icon);
  }
}
