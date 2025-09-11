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
  final int maxDescriptionLines;
  final int expandHintMinChars;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.isRead = false,
    this.isImportant = false,
    required this.createdAt,
    this.maxDescriptionLines = 2,
    this.expandHintMinChars = 120,
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
  bool _invokedOnTapOnExpand = false;

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color _getBackgroundColor() {
    if (widget.isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return AppColors.secondary.shade600.withOpacity(0.5);
    }
    return widget.isRead
        ? AppColors.secondary.shade400.withOpacity(0.1)
        : AppColors.secondary.shade600.withOpacity(0.5);
  }

  Color _getBorderColor() {
    if (widget.isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return AppColors.secondary.shade600.withOpacity(1);
    }
    return widget.isRead
        ? AppColors.secondary.shade600.withOpacity(0.5)
        : AppColors.secondary.shade600.withOpacity(1);
  }

  Color _getTitleColor() {
    if (widget.isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return const Color(0xFFF8FAFC);
    }
    return widget.isRead
        ? const Color(0xFFE2E8F0).withOpacity(0.8)
        : const Color(0xFFF8FAFC);
  }

  Color _getDescriptionColor() {
    if (widget.isImportant) {
      // Important notifications always use unread styling (don't reset when read)
      return const Color(0xFFE2E8F0);
    }
    return widget.isRead
        ? const Color(0xFFCBD5E1).withOpacity(0.8)
        : const Color(0xFFE2E8F0);
  }

  String _htmlToPlainText(String html) {
    // Convert common HTML line breaks to newlines
    String withBreaks = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</div\s*>', caseSensitive: false), '\n');

    // Strip remaining tags
    String noTags = withBreaks.replaceAll(RegExp(r'<[^>]*>'), '');

    // Normalize spaces while preserving newlines
    // 1) Collapse runs of spaces/tabs but keep newlines intact
    String normalized = noTags.replaceAll(RegExp(r'[\t\r\f ]+'), ' ');
    // 2) Trim each line and remove extra blank lines
    List<String> lines = normalized
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    return lines.join('\n');
  }

  Widget _buildToggleButton(bool isExpanded) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: _onToggleExpanded,
        icon: Icon(
          isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
          size: 14,
          color: const Color(0xFF00D4AA),
        ),
        label: Text(
          isExpanded ? 'Show less' : 'Show more',
          style: const TextStyle(
            color: Color(0xFF00D4AA),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  void _onToggleExpanded() {
    final expanding = !_isExpanded;
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (expanding && widget.onTap != null && !_invokedOnTapOnExpand) {
      _invokedOnTapOnExpand = true;
      widget.onTap!();
    }
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
                          widget.icon,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: _getTitleColor(),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Text(
                                _formatTime(widget.createdAt),
                                style: TextStyle(
                                  color:
                                      _getDescriptionColor().withOpacity(0.7),
                                  fontSize: 10,
                                  height: 1.2,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          if (widget.description != null) ...[
                            const SizedBox(height: 3),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final plainText =
                                    _htmlToPlainText(widget.description!);
                                final textStyle = TextStyle(
                                  color: _getDescriptionColor(),
                                  fontSize: 11,
                                  letterSpacing: 0.2,
                                  height: 1.3,
                                );

                                final textPainter = TextPainter(
                                  text: TextSpan(
                                      text: plainText, style: textStyle),
                                  maxLines: null,
                                  textDirection: Directionality.of(context),
                                )..layout(maxWidth: constraints.maxWidth);

                                final lineHeight =
                                    textPainter.preferredLineHeight;
                                final maxLines = widget.maxDescriptionLines;
                                final hasOverflow =
                                    textPainter.computeLineMetrics().length >
                                        maxLines;
                                final double extraSpace = 8.0;
                                final collapsedHeight =
                                    lineHeight * maxLines + extraSpace;

                                final baseStyle = {
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                  ),
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                  ),
                                };

                                final commonStyle = baseStyle;

                                final truncatedStyle = {
                                  ...baseStyle,
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                    maxLines: maxLines,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                    maxLines: maxLines,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                };

                                final fullHtml = Html(
                                  data: widget.description!,
                                  style: commonStyle,
                                );

                                final truncatedHtml = Html(
                                  data: widget.description!,
                                  style: truncatedStyle,
                                );

                                final descWidget = _isExpanded
                                    ? fullHtml
                                    : (hasOverflow ? truncatedHtml : fullHtml);

                                if (_isExpanded) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      descWidget,
                                      const SizedBox(height: 0),
                                      _buildToggleButton(true),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: collapsedHeight,
                                        child: descWidget,
                                      ),
                                      const SizedBox(height: 0),
                                      hasOverflow
                                          ? _buildToggleButton(false)
                                          : const SizedBox(height: 24),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Unread indicator - positioned outside the padded content
          if (!widget.isRead)
            Positioned(
              top: 6,
              right: 6,
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
    );
  }
}
