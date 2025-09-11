import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/app_colors.dart';
import 'package:smore_mobile_app/models/user_notification.dart';

class NotificationItem extends StatefulWidget {
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

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isExpanded = false;
  double? _fullHeight;
  final GlobalKey _fullKey = GlobalKey();

  static const double maxDescriptionHeight =
      40.0; // Adjust based on testing; approximates space for ~3 lines + margins

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color _getBackgroundColor() {
    if (widget.isImportant) {
      return AppColors.secondary.shade600.withOpacity(0.5);
    }
    return widget.isRead
        ? AppColors.secondary.shade400.withOpacity(0.1)
        : AppColors.secondary.shade600.withOpacity(0.5);
  }

  Color _getBorderColor() {
    if (widget.isImportant) {
      return AppColors.secondary.shade600.withOpacity(1);
    }
    return widget.isRead
        ? AppColors.secondary.shade600.withOpacity(0.5)
        : AppColors.secondary.shade600.withOpacity(1);
  }

  Color _getTitleColor() {
    if (widget.isImportant) {
      return const Color(0xFFF8FAFC);
    }
    return widget.isRead
        ? const Color(0xFFE2E8F0).withOpacity(0.8)
        : const Color(0xFFF8FAFC);
  }

  Color _getDescriptionColor() {
    if (widget.isImportant) {
      return const Color(0xFFE2E8F0);
    }
    return widget.isRead
        ? const Color(0xFFCBD5E1).withOpacity(0.8)
        : const Color(0xFFE2E8F0);
  }

  Map<String, Style> _getBaseStyle() {
    return {
      "body": Style(
        margin: Margins.only(top: 4),
        padding: HtmlPaddings.zero,
        color: _getDescriptionColor(),
        fontSize: FontSize(12),
        lineHeight: LineHeight.number(1.2),
        letterSpacing: 0.2,
      ),
      "br": Style(margin: Margins.symmetric(vertical: 8)),
      "div": Style(
        margin: Margins.only(bottom: 4),
      ),
      ".empty-line": Style(
        margin: Margins.only(bottom: 8),
      ),
      "p": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        color: _getDescriptionColor(),
        fontSize: FontSize(12),
        lineHeight: LineHeight.number(1.2),
        letterSpacing: 0.2,
      ),
      ".sport-title": Style(
        fontSize: FontSize(14),
      ),
      ".sport-emoji": Style(
        fontSize: FontSize(14),
        margin: Margins.only(right: 12),
      ),
    };
  }

  bool get _needsTruncation =>
      _fullHeight != null && _fullHeight! > maxDescriptionHeight;

  Widget _buildDescription(String description) {
    final htmlWidget = Html(
      data: description,
      style: _getBaseStyle(),
    );

    if (!_isExpanded && _needsTruncation) {
      return Stack(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
              stops: [0.65, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: htmlWidget,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => _isExpanded = true),
              child: const Text(
                'Show More',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return htmlWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fullHeight == null && widget.description != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final renderBox =
            _fullKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          setState(() {
            _fullHeight = renderBox.size.height;
            if (_fullHeight! <= maxDescriptionHeight) {
              _isExpanded = true;
            }
          });
        }
      });
    }

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          widget.icon,
                          size: 20,
                          color: const Color(0xFFB7C9DB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                        color: _getTitleColor(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _formatTime(widget.createdAt),
                                    style: TextStyle(
                                      color: _getDescriptionColor()
                                          .withOpacity(0.7),
                                      fontSize: 10,
                                      height: 1.2,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.description != null) ...[
                                const SizedBox(height: 3),
                                if (_fullHeight == null)
                                  Offstage(
                                    child: Html(
                                      key: _fullKey,
                                      data: widget.description!,
                                      style: _getBaseStyle(),
                                    ),
                                  ),
                                ClipRect(
                                  child: SizedBox(
                                    height: _isExpanded
                                        ? null
                                        : maxDescriptionHeight,
                                    child:
                                        _buildDescription(widget.description!),
                                  ),
                                ),
                                if (_needsTruncation && _isExpanded)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _isExpanded = false),
                                      child: const Text(
                                        'Show Less',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!widget.isRead)
            Positioned(
              top: 6,
              right: 6,
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
    );
  }
}
