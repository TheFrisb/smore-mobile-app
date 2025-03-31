import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class PurchaseProvider with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final UserProvider userProvider;
  final DioClient _dioClient = DioClient();
  static final Logger logger = Logger();

  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isLoading = false;
  String? _error;
  String? _currentPredictionId;

  PurchaseProvider(this.userProvider) {
    _init();

    // list all products
    _inAppPurchase.queryProductDetails({'buy_prediction'}).then((response) {
      if (response.notFoundIDs.isNotEmpty) {
        logger.w('Product not found: ${response.notFoundIDs}');
      } else {
        _products = response.productDetails;
        notifyListeners();
      }
    });
  }

  List<ProductDetails> get products => _products;

  bool get isAvailable => _isAvailable;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAvailable = await _inAppPurchase.isAvailable();

      if (_isAvailable) {
        logger.i('In-app purchases are available');
      }

      if (!_isAvailable) {
        _error = 'In-app purchases are not available on this device.';
        logger.e(_error);
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch product details for purchasing predictions
      const productIds = {
        'buy_prediction'
      }; // Single product ID for all predictions
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);
      if (response.notFoundIDs.isNotEmpty) {
        logger.w('Product not found: ${response.notFoundIDs}');
      }
      _products = response.productDetails;
    } catch (e) {
      _error = 'Failed to initialize purchases: $e';
      logger.e(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Listen to purchase updates
    _inAppPurchase.purchaseStream.listen(_listenToPurchaseUpdated);
    // Restore previous purchases
    _inAppPurchase.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          logger.i('Purchase pending: ${purchaseDetails.productID}');
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _error = purchaseDetails.error?.message ?? 'Purchase error';
          logger.e('Purchase error: $_error');
          notifyListeners();
          break;
        case PurchaseStatus.canceled:
          logger.i('Purchase canceled: ${purchaseDetails.productID}');
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      logger.i('Verifying purchase: ${purchaseDetails.productID}');
      final response =
          await _dioClient.dio.post('/predictions/verify-purchase/', data: {
        'purchase_token':
            purchaseDetails.verificationData.serverVerificationData,
        'prediction_id': _currentPredictionId,
      });
      if (response.statusCode == 200) {
        logger.i('Purchase verified successfully');
        await userProvider.getUserDetails(); // Refresh user data
      }
    } catch (e) {
      _error = 'Failed to verify purchase: $e';
      logger.e(_error);
      notifyListeners();
    }
  }

  Future<void> buyPrediction(String predictionId) async {
    _isLoading = true;
    _error = null;
    _currentPredictionId = predictionId; // Store prediction ID for verification
    notifyListeners();

    try {
      final product = _products.firstWhere((p) => p.id == 'buy_prediction');
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _error = 'Failed to initiate purchase: $e';
      logger.e(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _error = 'Failed to restore purchases: $e';
      logger.e(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
