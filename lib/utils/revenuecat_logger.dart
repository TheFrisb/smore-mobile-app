import 'package:logger/logger.dart';

import '../service/dio_client.dart';

/// Log levels for backend
enum InternalLogLevel {
  info('INFO'),
  warning('WARNING'),
  error('ERROR');

  final String value;

  const InternalLogLevel(this.value);
}

/// Internal logging class for RevenueCat errors
/// Logs to both console and backend
class RevenueCatLogger {
  static final RevenueCatLogger _instance = RevenueCatLogger._internal();

  factory RevenueCatLogger() => _instance;

  RevenueCatLogger._internal();

  final Logger _consoleLogger = Logger();
  final DioClient _dioClient = DioClient();

  /// Log info message
  void info(String message, {Map<String, dynamic>? additionalData}) {
    _consoleLogger.i(message);
    _sendToBackend(message, InternalLogLevel.info, additionalData);
  }

  /// Log warning message
  void warning(String message, {Map<String, dynamic>? additionalData}) {
    _consoleLogger.w(message);
    _sendToBackend(message, InternalLogLevel.warning, additionalData);
  }

  /// Log error message
  void error(String message, {Map<String, dynamic>? additionalData}) {
    _consoleLogger.e(message);
    _sendToBackend(message, InternalLogLevel.error, additionalData);
  }

  /// Log error with exception details
  void errorWithException(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) {
    _consoleLogger.e(message, error: error, stackTrace: stackTrace);

    final enhancedData = <String, dynamic>{
      if (additionalData != null) ...additionalData,
      if (error != null) 'exception': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    };

    _sendToBackend(message, InternalLogLevel.error, enhancedData);
  }

  /// Send log to backend (non-blocking)
  void _sendToBackend(
    String message,
    InternalLogLevel level,
    Map<String, dynamic>? additionalData,
  ) {
    // Don't await - fire and forget
    _dioClient.dio.post(
      '/logs/',
      data: {
        'user': null, // Always null for now
        'message': {
          'text': message,
          'level': level.value,
          if (additionalData != null) ...additionalData,
        },
        'level': level.value,
      },
    ).catchError((error) {
      // Silently fail - don't want logging to break the app
      _consoleLogger.e('Failed to send log to backend: $error');
    });
  }

  /// Log RevenueCat error with structured data
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
    final logData = <String, dynamic>{
      'operation': operation,
      'errorType': errorType,
      'errorMessage': errorMessage,
      if (productId != null) 'productId': productId,
      if (errorCode != null) 'errorCode': errorCode,
      if (underlyingErrorMessage != null)
        'underlyingErrorMessage': underlyingErrorMessage,
      if (originalError != null) 'originalError': originalError.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    final message =
        'RevenueCat Error: $errorType during $operation${productId != null ? ' for product: $productId' : ''} - $errorMessage';

    errorWithException(
      message,
      error: originalError,
      stackTrace: stackTrace,
      additionalData: logData,
    );
  }

  /// Log RevenueCat success
  void logRevenueCatSuccess({
    required String operation,
    String? productId,
    String? transactionId,
    Map<String, dynamic>? additionalData,
  }) {
    final logData = <String, dynamic>{
      'operation': operation,
      if (productId != null) 'productId': productId,
      if (transactionId != null) 'transactionId': transactionId,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalData != null) ...additionalData,
    };

    final message =
        'RevenueCat Success: $operation${productId != null ? ' for product: $productId' : ''}';

    info(message, additionalData: logData);
  }

  /// Log RevenueCat warning
  void logRevenueCatWarning({
    required String operation,
    required String warningMessage,
    String? productId,
    Map<String, dynamic>? additionalData,
  }) {
    final logData = <String, dynamic>{
      'operation': operation,
      'warningMessage': warningMessage,
      if (productId != null) 'productId': productId,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalData != null) ...additionalData,
    };

    final message =
        'RevenueCat Warning: $operation${productId != null ? ' for product: $productId' : ''} - $warningMessage';

    warning(message, additionalData: logData);
  }

  /// Log RevenueCat info
  void logRevenueCatInfo({
    required String operation,
    required String infoMessage,
    String? productId,
    Map<String, dynamic>? additionalData,
  }) {
    final logData = <String, dynamic>{
      'operation': operation,
      'infoMessage': infoMessage,
      if (productId != null) 'productId': productId,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalData != null) ...additionalData,
    };

    final message =
        'RevenueCat Info: $operation${productId != null ? ' for product: $productId' : ''} - $infoMessage';

    info(message, additionalData: logData);
  }
}
