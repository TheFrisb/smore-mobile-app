import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'revenuecat_error_handler.dart';
import 'revenuecat_logger.dart';
import '../components/common/error_snackbar.dart';

/// Mixin for handling RevenueCat errors in widgets
mixin RevenueCatErrorMixin<T extends StatefulWidget> on State<T> {
  static final Logger _logger = Logger();
  final RevenueCatErrorHandler _errorHandler = RevenueCatErrorHandler();
  final RevenueCatLogger _revenueCatLogger = RevenueCatLogger();

  /// Handle RevenueCat errors with automatic logging and user notification
  void handleRevenueCatError(
    dynamic error,
    StackTrace? stackTrace, {
    String? productId,
    String? operation,
    VoidCallback? onError,
  }) {
    final revenueCatError = _errorHandler.handlePurchaseError(
      error,
      stackTrace,
      productId: productId,
      operation: operation,
    );

    // Log the error
    _errorHandler.logError(revenueCatError);

    // Show user notification if needed
    if (mounted) {
      ErrorSnackBar.showRevenueCatError(context, revenueCatError);
    }

    // Call custom error handler if provided
    onError?.call();
  }

  /// Execute a RevenueCat operation with error handling
  Future<T?> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    String? productId,
    String? operationName,
    VoidCallback? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      final result = await operation();
      
      if (onSuccess != null) {
        onSuccess();
      }
      
      return result;
    } catch (error, stackTrace) {
      handleRevenueCatError(
        error,
        stackTrace,
        productId: productId,
        operation: operationName,
        onError: onError,
      );
      return null;
    }
  }

  /// Show success message
  void showSuccessMessage(String message) {
    if (mounted) {
      ErrorSnackBar.showSuccess(context, message: message);
    }
  }

  /// Show info message
  void showInfoMessage(String message) {
    if (mounted) {
      ErrorSnackBar.showInfo(context, message: message);
    }
  }

  /// Show warning message
  void showWarningMessage(String message) {
    if (mounted) {
      ErrorSnackBar.showWarning(context, message: message);
    }
  }

  /// Show error message
  void showErrorMessage(String message) {
    if (mounted) {
      ErrorSnackBar.show(context, message: message);
    }
  }

  /// Log info message
  void logInfo(String message) {
    _revenueCatLogger.info(message);
  }

  /// Log warning message
  void logWarning(String message) {
    _revenueCatLogger.warning(message);
  }

  /// Log error message
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null || stackTrace != null) {
      _revenueCatLogger.errorWithException(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      _revenueCatLogger.error(message);
    }
  }

  /// Log RevenueCat specific info
  void logRevenueCatInfo({
    required String operation,
    required String infoMessage,
    String? productId,
    Map<String, dynamic>? additionalData,
  }) {
    _revenueCatLogger.logRevenueCatInfo(
      operation: operation,
      infoMessage: infoMessage,
      productId: productId,
      additionalData: additionalData,
    );
  }

  /// Log RevenueCat specific warning
  void logRevenueCatWarning({
    required String operation,
    required String warningMessage,
    String? productId,
    Map<String, dynamic>? additionalData,
  }) {
    _revenueCatLogger.logRevenueCatWarning(
      operation: operation,
      warningMessage: warningMessage,
      productId: productId,
      additionalData: additionalData,
    );
  }

  /// Log RevenueCat specific error
  void logRevenueCatError({
    required String operation,
    required String errorType,
    required String errorMessage,
    String? productId,
    String? errorCode,
    String? underlyingErrorMessage,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    _revenueCatLogger.logRevenueCatError(
      operation: operation,
      errorType: errorType,
      errorMessage: errorMessage,
      productId: productId,
      errorCode: errorCode,
      underlyingErrorMessage: underlyingErrorMessage,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  /// Log RevenueCat success
  void logRevenueCatSuccess({
    required String operation,
    String? productId,
    String? transactionId,
    Map<String, dynamic>? additionalData,
  }) {
    _revenueCatLogger.logRevenueCatSuccess(
      operation: operation,
      productId: productId,
      transactionId: transactionId,
      additionalData: additionalData,
    );
  }
} 