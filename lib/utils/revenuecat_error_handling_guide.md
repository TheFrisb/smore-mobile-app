# RevenueCat Centralized Error Handling Guide

This guide explains how to use the centralized error handling system for RevenueCat purchases, consumables, and subscriptions in your Flutter app. The system uses RevenueCat's official `PurchasesErrorCode` enum and `PurchasesErrorHelper` class for complete compatibility.

## Overview

The centralized error handling system provides:
- **Complete error coverage** - Uses RevenueCat's official `PurchasesErrorCode` enum
- **Structured error logging** with different log levels
- **User-friendly error messages** via snackbars
- **Consistent error handling** across all purchase operations
- **Automatic error categorization** and appropriate user notifications
- **Retry logic** for recoverable errors

## Components

### 1. RevenueCatErrorHandler
The main error handling service that processes and categorizes errors using RevenueCat's official error codes.

### 2. ErrorSnackBar
A reusable component for displaying error, success, warning, and info messages.

### 3. RevenueCatErrorMixin
A mixin that provides easy error handling methods for widgets.

## Error Types (Using RevenueCat's Official Enum)

The system uses RevenueCat's official `PurchasesErrorCode` enum, which includes:

### Common Errors
- **invalidAppUserIdError** - Invalid App User ID
- **invalidCredentialsError** - Invalid API credentials
- **invalidSubscriberAttributesError** - Invalid subscriber attributes
- **networkError** - Network connectivity issues
- **offlineConnectionError** - Device offline
- **operationAlreadyInProgressError** - Duplicate operation
- **storeProblemError** - App Store/Play Store issues
- **unexpectedBackendResponseError** - Unexpected server response
- **unknownBackendError** - Unknown server error
- **unknownError** - Unknown error

### Purchasing Errors
- **receiptAlreadyInUseError** - Receipt already associated with another account
- **invalidReceiptError** - Malformed or invalid receipt
- **invalidAppleSubscriptionKeyError** - Invalid Apple subscription key
- **missingReceiptFileError** - No receipt file available
- **ineligibleError** - User not eligible for offer
- **insufficientPermissionsError** - Device lacks purchase permissions
- **paymentPendingError** - Payment requires additional action
- **productAlreadyPurchasedError** - Product already active
- **productNotAvailableForPurchaseError** - Product not available
- **purchaseCancelledError** - User cancelled purchase
- **purchaseInvalidError** - Invalid purchase arguments
- **purchaseNotAllowedError** - Purchases disabled on device

### Additional Errors
- **apiEndpointBlocked** - API endpoint blocked
- **productRequestTimeout** - Product request timeout
- **beginRefundRequestError** - Refund request error
- **customerInfoError** - Customer info error
- **configurationError** - Configuration error
- And many more...

## Usage Examples

### Basic Usage in Widgets

```dart
import 'package:flutter/material.dart';
import '../utils/revenuecat_error_mixin.dart';

class MyPurchaseWidget extends StatefulWidget {
  @override
  _MyPurchaseWidgetState createState() => _MyPurchaseWidgetState();
}

class _MyPurchaseWidgetState extends State<MyPurchaseWidget>
    with RevenueCatErrorMixin {
  
  Future<void> _handlePurchase() async {
    try {
      // Your purchase logic here
      final result = await RevenueCatService().purchaseConsumable(
        ConsumableIdentifiers.singleTicket,
      );
      
      if (result.success) {
        showSuccessMessage('Purchase successful!');
      } else {
        showErrorMessage('Purchase failed: ${result.errorMessage}');
      }
    } catch (e, stackTrace) {
      handleRevenueCatError(
        e,
        stackTrace,
        productId: 'single_ticket',
        operation: 'consumable_purchase',
      );
    }
  }
}
```

### Using executeWithErrorHandling Helper

```dart
Future<void> _purchaseWithHelper() async {
  final result = await executeWithErrorHandling(
    () => RevenueCatService().purchaseSubscription(package),
    productId: package.identifier,
    operationName: 'subscription_purchase',
    onSuccess: () {
      // Handle success
      showSuccessMessage('Subscription activated!');
    },
    onError: () {
      // Handle error (optional)
      logError('Custom error handling');
    },
  );
  
  if (result != null) {
    // Handle successful result
  }
}
```

### Retry Logic for Recoverable Errors

```dart
Future<void> _purchaseWithRetry() async {
  final result = await executeWithErrorHandling(
    () => RevenueCatService().purchaseConsumable(
      ConsumableIdentifiers.singleTicket,
    ),
    productId: 'single_ticket',
    operationName: 'consumable_purchase',
  );

  if (result == null) {
    // Check if error is retryable
    final lastError = _errorHandler.getLastError();
    if (lastError != null && _errorHandler.isRetryableError(lastError)) {
      final delay = _errorHandler.getRetryDelay(lastError);
      showWarningMessage('Retrying in ${delay.inSeconds} seconds...');
      
      await Future.delayed(delay);
      // Retry the operation
      await _purchaseWithRetry();
    }
  }
}
```

### Direct ErrorSnackBar Usage

```dart
// Show error message
ErrorSnackBar.show(
  context,
  message: 'Something went wrong',
  duration: Duration(seconds: 5),
);

// Show success message
ErrorSnackBar.showSuccess(
  context,
  message: 'Operation completed successfully',
);

// Show warning message
ErrorSnackBar.showWarning(
  context,
  message: 'Please check your internet connection',
);

// Show info message
ErrorSnackBar.showInfo(
  context,
  message: 'Processing your request...',
);
```

### Error Logging

The system automatically logs errors with appropriate levels:

```dart
// Info level for user actions (cancellations)
logInfo('User cancelled purchase');

// Warning level for recoverable errors
logWarning('Network error, will retry');

// Error level for critical errors
logError('Purchase failed', error, stackTrace);
```

## Best Practices

### 1. Always Use the Mixin
For widgets that handle purchases, always use the `RevenueCatErrorMixin`:

```dart
class _MyWidgetState extends State<MyWidget> with RevenueCatErrorMixin {
  // Your widget implementation
}
```

### 2. Provide Context in Error Handling
Always provide product ID and operation name for better error tracking:

```dart
handleRevenueCatError(
  e,
  stackTrace,
  productId: 'subscription_monthly',
  operation: 'subscription_purchase',
);
```

### 3. Use Appropriate Success Messages
Show success messages to confirm user actions:

```dart
if (purchaseResult.success) {
  showSuccessMessage('Purchase completed successfully!');
}
```

### 4. Handle Loading States
Always manage loading states properly:

```dart
setState(() {
  _isLoading = true;
});

try {
  // Purchase logic
} finally {
  if (mounted) {
    setState(() {
      _isLoading = false;
    });
  }
}
```

### 5. Check Widget Mounted State
Always check if the widget is still mounted before updating state:

```dart
if (mounted) {
  setState(() {
    _isLoading = false;
  });
}
```

### 6. Implement Retry Logic for Recoverable Errors
According to RevenueCat documentation, some errors are retryable:

```dart
if (_errorHandler.isRetryableError(error)) {
  final delay = _errorHandler.getRetryDelay(error);
  // Implement retry logic with appropriate delay
}
```

## Error Message Customization

You can customize error messages by modifying the `_getUserMessage` method in `RevenueCatErrorHandler`:

```dart
// In revenuecat_error_handler.dart
case PurchasesErrorCode.networkError:
  return 'Please check your internet connection and try again.';
```

## Testing Error Handling

To test different error scenarios:

```dart
// Test network error
await _testNetworkError();

// Test user cancellation
await _testUserCancellation();

// Test store problems
await _testStoreProblem();

// Test retryable errors
await _testRetryableErrors();
```

## Integration with Analytics

You can extend the error handler to send errors to analytics services:

```dart
void logError(RevenueCatError error) {
  // Log to console
  _logger.e(error.message);
  
  // Send to analytics
  AnalyticsService.trackError(
    errorType: error.type.toString(),
    errorMessage: error.message,
    errorCode: error.errorCode,
    underlyingError: error.underlyingErrorMessage,
    productId: error.productId,
  );
}
```

## Platform-Specific Error Handling

The system automatically handles platform differences:

- **Android**: Primarily uses `PurchasesError` objects
- **iOS**: Uses `PlatformException` with `PurchasesErrorHelper.getErrorCode()`
- **Cross-platform**: Unified error types and messages

## Retryable vs Non-Retryable Errors

According to RevenueCat documentation:

### Retryable Errors
- Network errors
- Store problems
- Operation already in progress
- Offline connection errors

### Non-Retryable Errors
- User cancellations
- Invalid credentials
- Product not available
- Purchase not allowed
- Receipt already in use

## Error Recovery Strategies

1. **Network Errors**: Retry with exponential backoff
2. **Store Problems**: Retry after a delay
3. **User Cancellations**: No action needed
4. **Invalid Receipts**: Contact support
5. **Payment Pending**: Wait for user action

## Using RevenueCat's Official Error Handling

The system leverages RevenueCat's official error handling:

```dart
// For PlatformException (iOS)
final purchasesErrorCode = PurchasesErrorHelper.getErrorCode(platformException);

// For PurchasesError (Android)
final errorCode = purchasesError.code;

// Both map to the same PurchasesErrorCode enum
switch (errorCode) {
  case PurchasesErrorCode.purchaseCancelledError:
    // Handle user cancellation
    break;
  case PurchasesErrorCode.networkError:
    // Handle network error
    break;
  // ... handle other error types
}
```

This centralized error handling system ensures consistent, user-friendly error management across your entire app while providing comprehensive logging for debugging and monitoring, fully aligned with RevenueCat's official error handling system. 