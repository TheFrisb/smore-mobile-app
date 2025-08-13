// service/revenue_cat_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smore_mobile_app/constants/constants.dart';

enum ConsumableIdentifiers {
  dailyOffer("daily_offer"),
  singleTicket("single_ticket"),
  singlePrediction("single_prediction");

  final String value;

  const ConsumableIdentifiers(this.value);
}

enum SubscriptionIdentifiers {
  soccer("soccer_subscription"),
  basketball("basketball_subscription"),
  aiAnalyst("ai_subscription");

  final String value;

  const SubscriptionIdentifiers(this.value);
}

enum EntitlementPeriod {
  monthly("monthly"),
  yearly("yearly");

  final String value;

  const EntitlementPeriod(this.value);
}

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();

  factory RevenueCatService() => _instance;

  RevenueCatService._internal();

  static final Logger logger = Logger();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize RevenueCat with platform-specific API keys
  Future<void> initialize() async {
    if (_isInitialized) {
      logger.i('RevenueCat already initialized');
      return;
    }

    try {
      logger.i('Initializing RevenueCat...');

      // Set up logging for debugging
      Purchases.setLogLevel(LogLevel.debug);

      // Initialize with platform-specific API key
      String apiKey;
      if (defaultTargetPlatform == TargetPlatform.android) {
        apiKey = Constants.revenueCatGooglePublicKey;
        logger.i('Using Android API key');
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        apiKey = Constants.revenueCatApplePublicKey;
        logger.i('Using iOS API key');
      } else {
        throw UnsupportedError('Platform not supported');
      }

      await Purchases.configure(PurchasesConfiguration(apiKey));
      Purchases.getCustomerInfo();

      _isInitialized = true;
      logger.i('RevenueCat initialized successfully');
    } catch (e) {
      logger.e('Failed to initialize RevenueCat: $e');
      rethrow;
    }
  }

  Future<void> setUserId(int userId) async {
    if (!_isInitialized) {
      logger.w('RevenueCat not initialized, skipping setUserId');
      return;
    }

    try {
      logger.i('Setting RevenueCat user ID: $userId');
      await Purchases.logIn(userId.toString());
      logger.i('User ID set successfully');
    } catch (e) {
      logger.e('Failed to set user ID: $e');
      rethrow;
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      logger.i('Fetching RevenueCat offerings...');
      final offerings = await Purchases.getOfferings();
      logger.i('Offerings fetched successfully');
      return offerings;
    } catch (e) {
      logger.e('Failed to get offerings: $e');
      return null;
    }
  }

  Future<Offering?> getOffering(String offeringId) async {
    final offerings = await getOfferings();
    if (offerings == null || offerings.current == null) {
      logger.e('No offerings available');
      return null;
    }

    final offering = offerings.getOffering(offeringId);
    if (offering == null) {
      logger.e('Offering "$offeringId" not found');
      return null;
    }

    return offering;
  }

  Future<Package?> getConsumablePackage(
      ConsumableIdentifiers consumableId) async {
    final offerings = await getOfferings();
    if (offerings == null || offerings.current == null) {
      logger.e('No offerings available');
      return null;
    }

    final offering = offerings.getOffering(consumableId.value);
    if (offering == null) {
      logger.e('Offering "${consumableId.value}" not found');
      return null;
    }

    final pkg = offering.getPackage('consumable');
    if (pkg == null) {
      logger.e(
          'Package "consumable" not found for offering "${consumableId.value}"');
      return null;
    }

    return pkg;
  }

  Future<ConsumablePurchaseResult> purchaseSubscription(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      final txnId = purchaseResult.storeTransaction.transactionIdentifier ?? '';
      logger
          .i('Subscription purchase successful for ID: ${package.identifier}');

      return ConsumablePurchaseResult(
        success: true,
        transactionId: txnId,
      );
    } on PlatformException catch (e, st) {
      final msg = e.message ?? 'Unknown platform error';
      logger.e(
          'Subscription purchase failed for ID: ${package.identifier}: $msg',
          stackTrace: st,
          error: e);
      return ConsumablePurchaseResult(
        success: false,
        errorMessage: msg,
        errorCode: e.code,
      );
    } catch (e, st) {
      final msg = e.toString();
      logger.e('Unexpected error purchasing ${package.identifier}: $msg',
          stackTrace: st, error: e);
      return ConsumablePurchaseResult(
        success: false,
        errorMessage: msg,
      );
    }
  }

  Future<ConsumablePurchaseResult> purchaseConsumable(
      ConsumableIdentifiers consumableId) async {
    logger.i('Initiating consumable purchase for ID: ${consumableId.value}');

    final offerings = await getOfferings();
    if (offerings == null || offerings.current == null) {
      const msg = 'No offerings available';
      logger.e(msg);
      return ConsumablePurchaseResult(success: false, errorMessage: msg);
    }

    final offering = offerings.getOffering(consumableId.value);
    if (offering == null) {
      final msg = 'Offering "${consumableId.value}" not found';
      logger.e(msg);
      return ConsumablePurchaseResult(success: false, errorMessage: msg);
    }

    final pkg = offering.getPackage('consumable');
    if (pkg == null) {
      final msg =
          'Package "${consumableId.value}" not found for offering ID: ${offering.identifier}';
      logger.e(msg);
      return ConsumablePurchaseResult(success: false, errorMessage: msg);
    }

    try {
      final purchaseResult = await Purchases.purchasePackage(pkg);
      final txnId = purchaseResult.storeTransaction.transactionIdentifier ?? '';
      logger.i('Consumable purchase successful for ID: ${consumableId.value}');

      return ConsumablePurchaseResult(
        success: true,
        transactionId: txnId,
      );
    } on PlatformException catch (e, st) {
      final msg = e.message ?? 'Unknown platform error';
      logger.e('Consumable purchase failed for ID: ${consumableId.value}: $msg',
          stackTrace: st, error: e);
      return ConsumablePurchaseResult(
        success: false,
        errorMessage: msg,
        errorCode: e.code,
      );
    } catch (e, st) {
      final msg = e.toString();
      logger.e('Unexpected error purchasing ${consumableId.value}: $msg',
          stackTrace: st, error: e);
      return ConsumablePurchaseResult(
        success: false,
        errorMessage: msg,
      );
    }
  }

  bool customerInfoHasActiveEntitlement(CustomerInfo customerInfo,
      Package package, EntitlementPeriod entitlementPeriod) {
    if (!_isInitialized) {
      logger.w('RevenueCat not initialized, cannot check subscription');
      return false;
    }

    String productId = _getProductId(package);

    String queriedEntitlementId = '${entitlementPeriod.value}_$productId';
    for (var entry in customerInfo.entitlements.active.entries) {
      final key = entry.key;
      final EntitlementInfo entitlement = entry.value;
      logger.i('Active entitlement: $key - ${entitlement.identifier}');
      logger.i('Product ID: ${entitlement.productIdentifier}');

      if (entitlement.identifier == queriedEntitlementId) {
        logger.i(
            'User has active entitlement for subscription "${package.identifier}" with period "${entitlementPeriod.value}"');
        return true;
      }
    }

    logger.i(
        'User does not have active entitlement for queried entitlement ID "$queriedEntitlementId"');
    return false;
  }

  Future<bool> userHasActiveEntitlement(SubscriptionIdentifiers subscriptionId,
      EntitlementPeriod entitlementPeriod) async {
    if (!_isInitialized) {
      logger.w('RevenueCat not initialized, cannot check subscription');
      return false;
    }

    final Offering? offering = await getOffering(subscriptionId.value);
    if (offering == null) {
      logger.e('Offering for subscription "${subscriptionId.value}" not found');
      return false;
    }

    final Package? package = entitlementPeriod == EntitlementPeriod.monthly
        ? offering.monthly
        : offering.annual;

    if (package == null) {
      logger.e(
          'No package found for subscription "${subscriptionId.value}" with period "${entitlementPeriod.value}"');
      return false;
    }

    String productId = _getProductId(package);
    String queriedEntitlementId = '${entitlementPeriod.value}_$productId';
    final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    for (var entry in customerInfo.entitlements.active.entries) {
      final key = entry.key;
      final EntitlementInfo entitlement = entry.value;
      logger.i('Active entitlement: $key - ${entitlement.identifier}');
      logger.i('Product ID: ${entitlement.productIdentifier}');

      if (entitlement.identifier == queriedEntitlementId) {
        logger.i(
            'User has active entitlement for subscription "${subscriptionId.value}" with period "${entitlementPeriod.value}"');
        return true;
      }
    }

    logger.i(
        'User does not have active entitlement for subscription "${subscriptionId.value}" with period "${entitlementPeriod.value}"');
    return false;
  }

  String _getProductId(Package package) {
    String storeProductId = package.storeProduct.identifier;

    if (storeProductId.startsWith("com.smore.")) {
      storeProductId = storeProductId.replaceFirst("com.smore.", "");
      return storeProductId.split('_').sublist(1).join('_');
    }

    if (storeProductId.contains(':')) {
      return storeProductId.split(':')[0];
    }

    return '';
  }
}

class ConsumablePurchaseResult {
  final bool success;
  final String? transactionId;
  final String? entitlementId;
  final String? errorMessage;
  final String? errorCode;

  ConsumablePurchaseResult({
    required this.success,
    this.transactionId,
    this.entitlementId,
    this.errorMessage,
    this.errorCode,
  });
}

class SubscribedProduct {
  final String productName;
  final double price;
  final String period;

  SubscribedProduct({
    required this.productName,
    required this.price,
    required this.period,
  });
}
