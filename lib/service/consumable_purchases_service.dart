import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class ConsumablePurchasesService {
  static final ConsumablePurchasesService _instance =
      ConsumablePurchasesService._internal();

  factory ConsumablePurchasesService() => _instance;

  ConsumablePurchasesService._internal();

  static final Logger logger = Logger();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) {
      logger.i('ConsumablePurchasesService already initialized');
      return;
    }

    try {
      logger.i('Initializing ConsumablePurchasesService...');
      _isInitialized = true;
      logger.i('ConsumablePurchasesService initialized successfully');
    } catch (e) {
      logger.e('Failed to initialize ConsumablePurchasesService: $e');
      rethrow;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      logger.i('Restoring purchases...');
      final customerInfo = await Purchases.restorePurchases();
      logger.i('Purchases restored successfully');
      return customerInfo.entitlements.active.isNotEmpty;
    } catch (e) {
      logger.e('Failed to restore purchases: $e');
      return false;
    }
  }

  /// Get customer info with purchase history
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      logger.e('Failed to get customer info: $e');
      return null;
    }
  }
}
