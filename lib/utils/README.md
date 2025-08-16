# Centralized RevenueCat Error Handling System

This directory contains a comprehensive error handling system for RevenueCat purchases, consumables, and subscriptions in your Flutter app. The system uses RevenueCat's official `PurchasesErrorCode` enum and `PurchasesErrorHelper` class for complete compatibility.

## Files Overview

### Core Error Handling
- **`revenuecat_error_handler.dart`** - Main error handling service that processes and categorizes RevenueCat errors using official error codes
- **`revenuecat_error_mixin.dart`** - Mixin providing easy error handling methods for widgets
- **`errors.dart`** - General error handling utilities (existing)

### UI Components
- **`../components/common/error_snackbar.dart`** - Reusable snackbar component for displaying error messages
- **`../components/examples/purchase_example_widget.dart`** - Example widget demonstrating usage

### Documentation
- **`revenuecat_error_handling_guide.md`** - Comprehensive usage guide
- **`README.md`** - This file

## Key Features

### ✅ Complete Error Coverage
- Uses RevenueCat's official `PurchasesErrorCode` enum
- Platform-specific error handling (Android/iOS)
- Comprehensive error categorization

### ✅ Centralized Error Processing
- All RevenueCat errors are processed through a single service
- Automatic error categorization and logging
- Consistent error handling across the app

### ✅ User-Friendly Error Messages
- Automatic snackbar notifications for errors
- No notifications for user cancellations
- Different message types: error, success, warning, info

### ✅ Structured Logging
- Different log levels based on error type
- Detailed error information for debugging
- Stack traces preserved for critical errors
- Underlying error messages captured

### ✅ Easy Integration
- Simple mixin for widgets
- Helper methods for common operations
- Automatic loading state management

### ✅ Retry Logic
- Automatic retry for recoverable errors
- Configurable retry delays
- Smart error categorization

### ✅ Error Types Handled
- **Common Errors**: Network, credentials, app user ID, etc.
- **Purchasing Errors**: Receipt issues, product availability, permissions, etc.
- **Additional Errors**: API blocking, timeouts, refunds, etc.
- **Platform-Specific**: iOS and Android specific error handling

## Quick Start

1. **Add the mixin to your widget:**
```dart
class _MyWidgetState extends State<MyWidget> with RevenueCatErrorMixin {
  // Your widget implementation
}
```

2. **Handle errors automatically:**
```dart
try {
  final result = await RevenueCatService().purchaseConsumable(
    ConsumableIdentifiers.singleTicket,
  );
  
  if (result.success) {
    showSuccessMessage('Purchase successful!');
  }
} catch (e, stackTrace) {
  handleRevenueCatError(
    e,
    stackTrace,
    productId: 'single_ticket',
    operation: 'consumable_purchase',
  );
}
```

3. **Use helper methods:**
```dart
final result = await executeWithErrorHandling(
  () => RevenueCatService().purchaseSubscription(package),
  productId: package.identifier,
  operationName: 'subscription_purchase',
  onSuccess: () => showSuccessMessage('Subscription activated!'),
);
```

4. **Implement retry logic:**
```dart
if (_errorHandler.isRetryableError(error)) {
  final delay = _errorHandler.getRetryDelay(error);
  // Implement retry with appropriate delay
}
```

## Benefits

- **Official Compatibility**: Uses RevenueCat's official error codes
- **Completeness**: Covers all RevenueCat error types
- **Consistency**: All errors handled the same way across the app
- **User Experience**: Clear, helpful error messages
- **Developer Experience**: Easy to implement and maintain
- **Debugging**: Comprehensive logging for troubleshooting
- **Maintainability**: Centralized error handling logic
- **Reliability**: Retry logic for recoverable errors

## Integration Status

The following components have been updated to use the centralized error handling:

- ✅ `RevenueCatService` - Core service updated with comprehensive error handling
- ✅ `SubscriptionButton` - Purchase button component
- ✅ `UnlockButton` - Consumable purchase button
- ✅ Error snackbar system implemented
- ✅ Example widget created for testing

## Error Categories

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

### Platform-Specific Handling
- **Android**: `PurchasesError` objects with detailed error information
- **iOS**: `PlatformException` with `PurchasesErrorHelper.getErrorCode()`
- **Cross-platform**: Unified error types and user messages

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

## Next Steps

1. Test the error handling with different scenarios
2. Customize error messages as needed
3. Implement retry logic for recoverable errors
4. Integrate with analytics services if required
5. Add more specific error handling for your use cases

For detailed usage instructions, see `revenuecat_error_handling_guide.md`. 