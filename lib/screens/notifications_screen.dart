import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/notification_item.dart';

import '../app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    // August 25, 2024
    {
      'icon': '🌟',
      'title': 'Good Morning, SMORE Fam!',
      'description':
          "It's a brand-new day, and we're all set to chase down one more winning day! 💪🔥",
      'isRead': false,
      'date': '2024-08-25',
    },
    {
      'icon': '💵',
      'title': "Don't miss out!",
      'description':
          'Single picks & parlays on sale for 9.99\$ each. Unlock daily selection for 24.99\$ or Premium Channel for 69.99\$/month.',
      'isRead': false,
      'date': '2024-08-25',
    },
    {
      'icon': '⚽️',
      'title': '🇩🇪 Germany: Super Cup',
      'description':
          'Stuttgart vs. Bayern Munich - Over 0.5 (1st Half) & Over 2.5 Goals @ 1.47',
      'isRead': false,
      'date': '2024-08-25',
    },
    {
      'icon': '🎉',
      'title': 'Parlay 1 win',
      'description': 'Congratulations! Your 3-leg parlay hit!',
      'isRead': true,
      'date': '2024-08-25',
    },
    {
      'icon': '🏀',
      'title': '🇺🇸 NBA: Lakers vs. Warriors',
      'description': 'Lakers -5.5 @ 1.85 - Final Score: 112-105 ✅',
      'isRead': true,
      'date': '2024-08-25',
    },

    // August 24, 2024
    {
      'icon': '⚽️',
      'title': '🇪🇸 La Liga: Real Madrid',
      'description': 'Real Madrid -1.5 @ 1.65 - Final Score: 3-1 ✅',
      'isRead': true,
      'date': '2024-08-24',
    },
    {
      'icon': '🎯',
      'title': 'Premium Channel Update',
      'description':
          'New risk management protocols available in Premium Channel',
      'isRead': true,
      'date': '2024-08-24',
    },

    // August 20, 2024
    {
      'icon': '📊',
      'title': 'Weekly Stats Report',
      'description': 'Your week: 12 wins, 3 losses (80% accuracy)',
      'isRead': true,
      'date': '2024-08-20',
    },
    {
      'icon': '🔔',
      'title': 'New Feature Available',
      'description': 'Live bet tracking now available in the app',
      'isRead': true,
      'date': '2024-08-20',
    },
  ];

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
      body: Column(
        children: [
          // Header with notification count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.bell,
                  color: Color(0xFFB7C9DB),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_notifications.where((n) => !n['isRead']).length} unread',
                  style: const TextStyle(
                    color: Color(0xFF8A9BAE),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Notifications list
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  void _onNotificationTap(int index) {
    setState(() {
      _notifications[index]['isRead'] = true;
    });

    // Here you could add navigation logic based on notification type
    // For now, just mark as read
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  Widget _buildNotificationsList() {
    // Group notifications by date
    final Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

    for (var notification in _notifications) {
      final date = notification['date'] as String;
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }

    // Sort dates in descending order (most recent first)
    final sortedDates = groupedNotifications.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sortedDates.length,
      itemBuilder: (context, dateIndex) {
        final date = sortedDates[dateIndex];
        final notificationsForDate = groupedNotifications[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                _formatDate(date),
                style: TextStyle(
                  color: AppColors.secondary.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Notifications for this date
            ...notificationsForDate.map((notification) {
              final index = _notifications.indexOf(notification);
              return NotificationItem(
                icon: notification['icon'],
                title: notification['title'],
                description: notification['description'],
                isRead: notification['isRead'],
                onTap: () => _onNotificationTap(index),
              );
            }),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM').format(date);
    }
  }
}
