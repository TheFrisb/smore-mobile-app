import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/components/notification_item.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    // Unread notifications (3)
    {
      'icon': '🌟',
      'title': 'Good Morning, SMORE Fam!',
      'description': "It's a brand-new day, and we're all set to chase down one more winning day! 💪🔥",
      'isRead': false,
    },
    {
      'icon': '💵',
      'title': "Don't miss out!",
      'description': 'Single picks & parlays on sale for 9.99\$ each. Unlock daily selection for 24.99\$ or Premium Channel for 69.99\$/month.',
      'isRead': false,
    },
    {
      'icon': '⚽️',
      'title': '🇩🇪 Germany: Super Cup',
      'description': 'Stuttgart vs. Bayern Munich - Over 0.5 (1st Half) & Over 2.5 Goals @ 1.47',
      'isRead': false,
    },
    // Read notifications (6)
    {
      'icon': '🎉',
      'title': 'Parlay 1 win',
      'description': 'Congratulations! Your 3-leg parlay hit!',
      'isRead': true,
    },
    {
      'icon': '🏀',
      'title': '🇺🇸 NBA: Lakers vs. Warriors',
      'description': 'Lakers -5.5 @ 1.85 - Final Score: 112-105 ✅',
      'isRead': true,
    },
    {
      'icon': '⚽️',
      'title': '🇪🇸 La Liga: Real Madrid',
      'description': 'Real Madrid -1.5 @ 1.65 - Final Score: 3-1 ✅',
      'isRead': true,
    },
    {
      'icon': '🎯',
      'title': 'Premium Channel Update',
      'description': 'New risk management protocols available in Premium Channel',
      'isRead': true,
    },
    {
      'icon': '📊',
      'title': 'Weekly Stats Report',
      'description': 'Your week: 12 wins, 3 losses (80% accuracy)',
      'isRead': true,
    },
    {
      'icon': '🔔',
      'title': 'New Feature Available',
      'description': 'Live bet tracking now available in the app',
      'isRead': true,
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
                Icon(
                  LucideIcons.bell,
                  color: const Color(0xFFB7C9DB),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return NotificationItem(
                  icon: notification['icon'],
                  title: notification['title'],
                  description: notification['description'],
                  isRead: notification['isRead'],
                  onTap: () => _onNotificationTap(index),
                );
              },
            ),
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
}
