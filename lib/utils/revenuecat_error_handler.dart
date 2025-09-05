import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'backend_logger.dart';

/// Error information structure
class RevenueCatError {
  final PurchasesErrorCode type;
  final String message;
  final String? userMessage;
  final String? errorCode;
  final String? underlyingErrorMessage;
  final dynamic originalError;
  final StackTrace? stackTrace;

  RevenueCatError({
    required this.type,
    required this.message,
    this.userMessage,
    this.errorCode,
    this.underlyingErrorMessage,
    this.originalError,
    this.stackTrace,
  });
}

/// Centralized error handling for RevenueCat purchases
class RevenueCatErrorHandler {
  static final RevenueCatErrorHandler _instance =
      RevenueCatErrorHandler._internal();

  factory RevenueCatErrorHandler() => _instance;

  RevenueCatErrorHandler._internal();

  static final Logger _logger = Logger();
  final BackendLogger _revenueCatLogger = BackendLogger();

  /// Handle RevenueCat purchase errors
  RevenueCatError handlePurchaseError(
    dynamic error,
    StackTrace? stackTrace, {
    String? productId,
    String? operation,
  }) {
    final operationName = operation ?? 'purchase';
    final productInfo = productId != null ? ' for product: $productId' : '';

    if (error is PurchasesError) {
      return _handlePurchasesError(
          error, stackTrace, operationName, productInfo);
    } else if (error is PlatformException) {
      return _handlePlatformException(
          error, stackTrace, operationName, productInfo);
    } else {
      return _handleGenericError(error, stackTrace, operationName, productInfo);
    }
  }

  /// Handle PurchasesError (Android) - primary error type
  RevenueCatError _handlePurchasesError(
    PurchasesError error,
    StackTrace? stackTrace,
    String operation,
    String productInfo,
  ) {
    final errorCode = error.code;
    final errorMessage = error.message;
    final underlyingErrorMessage = error.underlyingErrorMessage;

    _revenueCatLogger.logRevenueCatError(
      operation: operation,
      errorType: errorCode.toString(),
      errorMessage: errorMessage,
      productId: productInfo.isNotEmpty ? productInfo.split(': ').last : null,
      errorCode: errorCode.toString(),
      underlyingErrorMessage: underlyingErrorMessage,
      originalError: error,
      stackTrace: stackTrace,
    );

    return RevenueCatError(
      type: errorCode,
      message: 'Error during $operation$productInfo: $errorMessage',
      userMessage: _getUserMessage(errorCode, errorMessage),
      errorCode: errorCode.toString(),
      underlyingErrorMessage: underlyingErrorMessage,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Handle PlatformException errors (iOS)
  RevenueCatError _handlePlatformException(
    PlatformException error,
    StackTrace? stackTrace,
    String operation,
    String productInfo,
  ) {
    final errorCode = error.code;
    final errorMessage = error.message ?? 'Unknown platform error';

    // Convert PlatformException to PurchasesErrorCode using RevenueCat's helper
    final purchasesErrorCode = PurchasesErrorHelper.getErrorCode(error);

    _revenueCatLogger.logRevenueCatError(
      operation: operation,
      errorType: purchasesErrorCode.toString(),
      errorMessage: errorMessage,
      productId: productInfo.isNotEmpty ? productInfo.split(': ').last : null,
      errorCode: errorCode,
      originalError: error,
      stackTrace: stackTrace,
    );

    return RevenueCatError(
      type: purchasesErrorCode,
      message: 'Platform error during $operation$productInfo: $errorMessage',
      userMessage: _getUserMessage(purchasesErrorCode, errorMessage),
      errorCode: errorCode,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Handle generic errors
  RevenueCatError _handleGenericError(
    dynamic error,
    StackTrace? stackTrace,
    String operation,
    String productInfo,
  ) {
    final errorMessage = error.toString();

    _revenueCatLogger.logRevenueCatError(
      operation: operation,
      errorType: 'UNKNOWN_ERROR',
      errorMessage: errorMessage,
      productId: productInfo.isNotEmpty ? productInfo.split(': ').last : null,
      originalError: error,
      stackTrace: stackTrace,
    );

    return RevenueCatError(
      type: PurchasesErrorCode.unknownError,
      message: 'Generic error during $operation$productInfo: $errorMessage',
      userMessage: 'An unexpected error occurred. Please try again.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Get user-friendly error message based on RevenueCat error code
  String? _getUserMessage(
      PurchasesErrorCode errorCode, String? originalMessage) {
    switch (errorCode) {
      // Common errors
      case PurchasesErrorCode.invalidAppUserIdError:
        return 'There was an issue with your account. Please try logging in again.';

      case PurchasesErrorCode.invalidCredentialsError:
        return 'There was an issue with the app configuration. Please contact support.';

      case PurchasesErrorCode.invalidSubscriberAttributesError:
        return 'There was an issue with your account information. Please try again.';

      case PurchasesErrorCode.networkError:
        return 'Please check your internet connection and try again.';

      case PurchasesErrorCode.offlineConnectionError:
        return 'You appear to be offline. Please check your internet connection and try again.';

      case PurchasesErrorCode.operationAlreadyInProgressError:
        return 'Please wait for the current operation to complete.';

      case PurchasesErrorCode.storeProblemError:
        return 'There was an issue with the app store. Please try again later.';

      case PurchasesErrorCode.unexpectedBackendResponseError:
        return 'There was an unexpected server response. Please try again.';

      case PurchasesErrorCode.unknownBackendError:
        return 'There was a server error. Please try again later.';

      // Purchasing errors
      case PurchasesErrorCode.receiptAlreadyInUseError:
        return 'This purchase is already associated with another account. Please restore purchases or contact support.';

      case PurchasesErrorCode.invalidReceiptError:
        return 'There was an issue with your purchase receipt. Please contact support.';

      case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
        return 'There was an issue with the subscription configuration. Please contact support.';

      case PurchasesErrorCode.missingReceiptFileError:
        return 'There was an issue with your purchase receipt. Please try again or contact support.';

      case PurchasesErrorCode.ineligibleError:
        return 'You are not eligible for this offer. Please check the terms and conditions.';

      case PurchasesErrorCode.insufficientPermissionsError:
        return 'You do not have permission to make purchases on this device. Please check your account settings.';

      case PurchasesErrorCode.paymentPendingError:
        return 'Your payment is being processed. Please wait a moment and check your email for instructions.';

      case PurchasesErrorCode.productAlreadyPurchasedError:
        return 'You already own this product. Please restore purchases if needed.';

      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        return 'This product is currently not available for purchase.';

      case PurchasesErrorCode.purchaseCancelledError:
        return null; // Don't show snackbar for user cancellation

      case PurchasesErrorCode.purchaseInvalidError:
        return 'There was an issue with your payment method. Please check your payment details and try again.';

      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Purchases are not allowed on this device. Please check your device settings.';

      case PurchasesErrorCode.receiptInUseByOtherSubscriberError:
        return 'This purchase is already associated with another account. Please restore purchases or contact support.';

      case PurchasesErrorCode.invalidPromotionalOfferError:
        return 'There was an issue with the promotional offer. Please try again.';

      case PurchasesErrorCode.apiEndpointBlocked:
        return 'There was an issue connecting to our servers. Please try again later.';

      case PurchasesErrorCode.productRequestTimeout:
        return 'The product request took too long. Please try again.';

      case PurchasesErrorCode.beginRefundRequestError:
        return 'There was an issue processing your refund request. Please contact support.';

      case PurchasesErrorCode.customerInfoError:
        return 'There was an issue loading your account information. Please try again.';

      case PurchasesErrorCode.systemInfoError:
        return 'There was an issue with the system. Please try again.';

      case PurchasesErrorCode.configurationError:
        return 'There was an issue with the app configuration. Please contact support.';

      case PurchasesErrorCode.unsupportedError:
        return 'This operation is not supported. Please contact support.';

      case PurchasesErrorCode.emptySubscriberAttributesError:
        return 'There was an issue with your account attributes. Please try again.';

      case PurchasesErrorCode.productDiscountMissingIdentifierError:
        return 'There was an issue with the product discount. Please try again.';

      case PurchasesErrorCode
            .productDiscountMissingSubscriptionGroupIdentifierError:
        return 'There was an issue with the subscription group. Please try again.';

      case PurchasesErrorCode.logOutWithAnonymousUserError:
        return 'You are already logged out.';

      case PurchasesErrorCode.unknownError:
      case PurchasesErrorCode.unknownNonNativeError:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Log error with structured information
  void logError(RevenueCatError error) {
    switch (error.type) {
      case PurchasesErrorCode.purchaseCancelledError:
        _revenueCatLogger.logRevenueCatInfo(
          operation: 'purchase_cancelled',
          infoMessage: 'User cancelled purchase',
          productId: error.errorCode,
        );
        break;
      case PurchasesErrorCode.networkError:
      case PurchasesErrorCode.offlineConnectionError:
      case PurchasesErrorCode.storeProblemError:
        _revenueCatLogger.logRevenueCatWarning(
          operation: 'recoverable_error',
          warningMessage: error.message,
          productId: error.errorCode,
          additionalData: {
            'errorType': error.type.toString(),
            'underlyingError': error.underlyingErrorMessage,
          },
        );
        break;
      default:
        _revenueCatLogger.logRevenueCatError(
          operation: 'error_occurred',
          errorType: error.type.toString(),
          errorMessage: error.message,
          productId: error.errorCode,
          errorCode: error.errorCode,
          underlyingErrorMessage: error.underlyingErrorMessage,
          originalError: error.originalError,
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Check if error should show user notification
  bool shouldShowUserNotification(RevenueCatError error) {
    return error.userMessage != null &&
        error.type != PurchasesErrorCode.purchaseCancelledError;
  }

  /// Get user-friendly error message
  String getUserMessage(RevenueCatError error) {
    return error.userMessage ??
        'An unexpected error occurred. Please try again.';
  }

  /// Check if error is retryable
  bool isRetryableError(RevenueCatError error) {
    switch (error.type) {
      case PurchasesErrorCode.networkError:
      case PurchasesErrorCode.offlineConnectionError:
      case PurchasesErrorCode.storeProblemError:
      case PurchasesErrorCode.operationAlreadyInProgressError:
        return true;
      default:
        return false;
    }
  }

  /// Get retry delay for retryable errors
  Duration getRetryDelay(RevenueCatError error) {
    switch (error.type) {
      case PurchasesErrorCode.networkError:
      case PurchasesErrorCode.offlineConnectionError:
        return const Duration(seconds: 2);
      case PurchasesErrorCode.storeProblemError:
        return const Duration(seconds: 5);
      case PurchasesErrorCode.operationAlreadyInProgressError:
        return const Duration(seconds: 1);
      default:
        return const Duration(seconds: 3);
    }
  }

  /// Log successful operation
  void logSuccess(String operation,
      {String? productId, String? transactionId}) {
    _revenueCatLogger.logRevenueCatSuccess(
      operation: operation,
      productId: productId,
      transactionId: transactionId,
    );
  }
}
