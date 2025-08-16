import 'package:flutter/material.dart';

import '../../utils/revenuecat_error_handler.dart';

/// Reusable error snackbar component for displaying error messages
class ErrorSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
    bool isError = true,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.info_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red[600] : Colors.blue[600],
      duration: duration ?? const Duration(seconds: 6),
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show RevenueCat error with automatic handling
  static void showRevenueCatError(
    BuildContext context,
    RevenueCatError error, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (!RevenueCatErrorHandler().shouldShowUserNotification(error)) {
      return; // Don't show snackbar for user cancellations
    }

    final message = RevenueCatErrorHandler().getUserMessage(error);

    show(
      context,
      message: message,
      duration: duration,
      action: action,
      isError: true,
    );
  }

  /// Show success message
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      action: action,
      isError: false,
    );
  }

  /// Show info message
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      action: action,
      isError: false,
    );
  }

  /// Show warning message
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange[600],
      duration: duration ?? const Duration(seconds: 4),
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
