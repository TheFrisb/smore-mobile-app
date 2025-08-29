import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/notification_item.dart';
import 'package:smore_mobile_app/providers/user_notification_provider.dart';

import '../app_colors.dart';
import '../models/user_notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D151E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D151E),
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFFB7C9DB),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.arrowLeft,
            color: Color(0xFFB7C9DB),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: BrandGradientLine(),
        ),
      ),
      body: Consumer<UserNotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading &&
              notificationProvider.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00D4AA),
              ),
            );
          }

          if (notificationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading notifications',
                    style: TextStyle(
                      color: AppColors.secondary.shade400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => notificationProvider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with notification count
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.bell,
                      color: Color(0xFFB7C9DB),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${notificationProvider.unreadCount} unread',
                      style: const TextStyle(
                        color: Color(0xFF8A9BAE),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: notificationProvider.unreadCount > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: () =>
                            notificationProvider.markAllNotificationsAsRead(),
                        child: const Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: Color(0xFF00D4AA),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Notifications list
              Expanded(
                child: _buildNotificationsList(context, notificationProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onNotificationTap(BuildContext context, UserNotification notification) {
    // Mark notification as read
    final provider =
        Provider.of<UserNotificationProvider>(context, listen: false);
    provider.markNotificationAsRead(notification.id);
  }

  Widget _buildNotificationsList(
      BuildContext context, UserNotificationProvider notificationProvider) {
    if (notificationProvider.notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bell icon with subtle styling
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF15212E),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: const Color(0xFF2D4763).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  LucideIcons.bell,
                  size: 36,
                  color: Color(0xFF8A9BAE),
                ),
              ),
              const SizedBox(height: 24),
              // Main message
              const Text(
                'All caught up!',
                style: TextStyle(
                  color: Color(0xFFB7C9DB),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                'You have no new notifications at the moment. We\'ll notify you when there\'s something important!',
                style: TextStyle(
                  color: Color(0xFF8A9BAE),
                  fontSize: 14,
                  height: 1.4,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Optional: Add a refresh button
              OutlinedButton.icon(
                onPressed: () => notificationProvider.refresh(),
                icon: const Icon(
                  LucideIcons.refreshCw,
                  size: 16,
                  color: Color(0xFF00D4AA),
                ),
                label: const Text(
                  'Refresh',
                  style: TextStyle(
                    color: Color(0xFF00D4AA),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF00D4AA),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notificationProvider.refresh(),
      color: const Color(0xFF00D4AA),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notificationProvider.sortedDateKeys.length,
        itemBuilder: (context, dateIndex) {
          final dateKey = notificationProvider.sortedDateKeys[dateIndex];
          final notificationsForDate =
              notificationProvider.getNotificationsForDate(dateKey);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    notificationProvider.getDisplayDate(dateKey),
                    style: TextStyle(
                      color: AppColors.secondary.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              // Notifications for this date
              ...notificationsForDate.map((notification) {
                return NotificationItem(
                  icon: notificationProvider.getNotificationIcon(notification),
                  title: notification.title,
                  description: notification.message,
                  isRead: notification.isRead,
                  onTap: () => _onNotificationTap(context, notification),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
