import 'package:flutter/material.dart';
import 'revenuecat_logger.dart';
import 'revenuecat_error_mixin.dart';

/// Example widget demonstrating the new RevenueCat logging system
class LoggingExampleWidget extends StatefulWidget {
  const LoggingExampleWidget({super.key});

  @override
  State<LoggingExampleWidget> createState() => _LoggingExampleWidgetState();
}

class _LoggingExampleWidgetState extends State<LoggingExampleWidget>
    with RevenueCatErrorMixin {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RevenueCat Logging Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basic logging examples
            ElevatedButton(
              onPressed: _testBasicLogging,
              child: const Text('Test Basic Logging'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _testRevenueCatSpecificLogging,
              child: const Text('Test RevenueCat Specific Logging'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _testErrorLogging,
              child: const Text('Test Error Logging'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _testSuccessLogging,
              child: const Text('Test Success Logging'),
            ),
            const SizedBox(height: 16),
            
            // Information card
            Card(
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logging Features:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Console logging with logger package'),
                    Text('• Backend logging via API (non-blocking)'),
                    Text('• Structured error data'),
                    Text('• Success tracking'),
                    Text('• Warning and info levels'),
                    Text('• Automatic error categorization'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Test basic logging methods
  void _testBasicLogging() {
    logInfo('This is an info message');
    logWarning('This is a warning message');
    logError('This is an error message');
    
    showSuccessMessage('Basic logging test completed!');
  }

  /// Test RevenueCat specific logging
  void _testRevenueCatSpecificLogging() {
    // Log info
    logRevenueCatInfo(
      operation: 'test_operation',
      infoMessage: 'Testing RevenueCat info logging',
      productId: 'test_product',
      additionalData: {'testKey': 'testValue'},
    );

    // Log warning
    logRevenueCatWarning(
      operation: 'test_operation',
      warningMessage: 'Testing RevenueCat warning logging',
      productId: 'test_product',
      additionalData: {'warningType': 'test_warning'},
    );

    // Log error
    logRevenueCatError(
      operation: 'test_operation',
      errorType: 'TEST_ERROR',
      errorMessage: 'Testing RevenueCat error logging',
      productId: 'test_product',
      errorCode: 'TEST_001',
      underlyingErrorMessage: 'Test underlying error',
      originalError: Exception('Test exception'),
      stackTrace: StackTrace.current,
    );

    // Log success
    logRevenueCatSuccess(
      operation: 'test_operation',
      productId: 'test_product',
      transactionId: 'test_transaction_123',
      additionalData: {'successType': 'test_success'},
    );

    showSuccessMessage('RevenueCat specific logging test completed!');
  }

  /// Test error logging with exceptions
  void _testErrorLogging() {
    try {
      // Simulate an error
      throw Exception('This is a test exception');
    } catch (e, stackTrace) {
      logError('Caught an exception during testing', e, stackTrace);
    }

    showSuccessMessage('Error logging test completed!');
  }

  /// Test success logging
  void _testSuccessLogging() {
    logRevenueCatSuccess(
      operation: 'example_success',
      productId: 'example_product',
      transactionId: 'example_transaction_456',
      additionalData: {
        'amount': 9.99,
        'currency': 'USD',
        'platform': 'iOS',
      },
    );

    showSuccessMessage('Success logging test completed!');
  }
}

/// Example of how to use the logging system in a purchase widget
class PurchaseWidgetExample extends StatefulWidget {
  const PurchaseWidgetExample({super.key});

  @override
  State<PurchaseWidgetExample> createState() => _PurchaseWidgetExampleState();
}

class _PurchaseWidgetExampleState extends State<PurchaseWidgetExample>
    with RevenueCatErrorMixin {
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePurchase,
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Simulate Purchase'),
    );
  }

  Future<void> _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate purchase process
      await Future.delayed(const Duration(seconds: 2));
      
      // Log success
      logRevenueCatSuccess(
        operation: 'simulated_purchase',
        productId: 'simulated_product',
        transactionId: 'sim_txn_${DateTime.now().millisecondsSinceEpoch}',
        additionalData: {
          'simulated': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      showSuccessMessage('Purchase completed successfully!');
    } catch (e, stackTrace) {
      // Log error
      logRevenueCatError(
        operation: 'simulated_purchase',
        errorType: 'SIMULATION_ERROR',
        errorMessage: 'Purchase simulation failed',
        productId: 'simulated_product',
        originalError: e,
        stackTrace: stackTrace,
      );

      showErrorMessage('Purchase failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
