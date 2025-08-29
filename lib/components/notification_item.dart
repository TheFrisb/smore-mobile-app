import 'package:flutter/material.dart';
import 'package:smore_mobile_app/app_colors.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final bool isRead;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.secondary.shade400.withOpacity(0.1)
            : AppColors.secondary.shade600.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRead
              ? AppColors.secondary.shade600.withOpacity(0.5)
              : AppColors.secondary.shade600.withOpacity(1),
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
                              color: isRead
                                  ? const Color(0xFFE2E8F0).withOpacity(0.8)
                                  : const Color(0xFFF8FAFC),
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
                                color: isRead
                                    ? const Color(0xFFCBD5E1).withOpacity(0.8)
                                    : const Color(0xFFE2E8F0),
                                fontSize: 11,
                                height: 1.3,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
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
