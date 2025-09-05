import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/app_colors.dart';
import 'package:smore_mobile_app/models/user_notification.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final bool isRead;
  final bool isImportant;
  final DateTime createdAt;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.isRead = false,
    this.isImportant = false,
    required this.createdAt,
  });

  static IconData getNotificationIcon(NotificationIcon? icon) {
    if (icon == null) {
      return LucideIcons.bell;
    }

    switch (icon) {
      case NotificationIcon.SOCCER:
        return Icons.sports_soccer;
      case NotificationIcon.BASKETBALL:
        return Icons.sports_basketball;
      case NotificationIcon.TROPHY:
        return LucideIcons.trophy;
      case NotificationIcon.CHECKMARK:
        return LucideIcons.circleCheck;
      case NotificationIcon.XMARK:
        return LucideIcons.circleX;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  Color _getBackgroundColor() {
    if (isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return AppColors.secondary.shade600.withOpacity(0.5);
    }
    return isRead
        ? AppColors.secondary.shade400.withOpacity(0.1)
        : AppColors.secondary.shade600.withOpacity(0.5);
  }

  Color _getBorderColor() {
    if (isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return AppColors.secondary.shade600.withOpacity(1);
    }
    return isRead
        ? AppColors.secondary.shade600.withOpacity(0.5)
        : AppColors.secondary.shade600.withOpacity(1);
  }

  Color _getTitleColor() {
    if (isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return const Color(0xFFF8FAFC);
    }
    return isRead
        ? const Color(0xFFE2E8F0).withOpacity(0.8)
        : const Color(0xFFF8FAFC);
  }

  Color _getDescriptionColor() {
    if (isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return const Color(0xFFE2E8F0);
    }
    return isRead
        ? const Color(0xFFCBD5E1).withOpacity(0.8)
        : const Color(0xFFE2E8F0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getBorderColor(),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                // Main content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.shade900,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.shade600.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 18,
                          color: const Color(0xFFB7C9DB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: _getTitleColor(),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          if (description != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              description!,
                              style: TextStyle(
                                color: _getDescriptionColor(),
                                fontSize: 11,
                                height: 1.3,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                          // const SizedBox(height: 4),
                          // Text(
                          //   _formatTime(createdAt),
                          //   style: TextStyle(
                          //     color: _getDescriptionColor().withOpacity(0.7),
                          //     fontSize: 10,
                          //     height: 1.2,
                          //     letterSpacing: 0.3,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Spacer to maintain consistent layout
                    const SizedBox(width: 16),
                  ],
                ),
                // Unread indicator - absolutely positioned
                if (!isRead)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4AA),
                        // Always use teal for unread indicator
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4AA).withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
