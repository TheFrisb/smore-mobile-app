// import 'dart:async'; // For StreamController
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:logger/logger.dart';
// import 'package:smore_mobile_app/providers/user_provider.dart';
// import 'package:smore_mobile_app/service/dio_client.dart';
//
// class PurchaseProvider with ChangeNotifier {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   final UserProvider userProvider;
//   final DioClient _dioClient = DioClient();
//   static final Logger logger = Logger();
//
//   List<ProductDetails> _products = [];
//   bool _isAvailable = false;
//   bool _isLoading = false;
//   String? _error;
//
//   final StreamController<void> _purchaseSuccessController =
//       StreamController.broadcast();
//
//   Stream<void> get purchaseSuccessStream => _purchaseSuccessController.stream;
//
//   PurchaseProvider(this.userProvider) {
//     _init();
//     _loadProducts();
//   }
//
//   List<ProductDetails> get products => _products;
//
//   bool get isAvailable => _isAvailable;
//
//   bool get isLoading => _isLoading;
//
//   String? get error => _error;
//
//   Future<void> _loadProducts() async {
//     final response =
//         await _inAppPurchase.queryProductDetails({'buy_prediction', 's', 's.'});
//     if (response.notFoundIDs.isNotEmpty) {
//       logger.w('Product not found: ${response.notFoundIDs}');
//     } else {
//       _products = response.productDetails;
//
//       logger.i('Products loaded: ${_products.map((p) => p.id).toList()}');
//       notifyListeners();
//     }
//   }
//
//   Future<void> _init() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       _isAvailable = await _inAppPurchase.isAvailable();
//       if (!_isAvailable) {
//         _error = 'In-app purchases are not available on this device.';
//         logger.e(_error);
//         return;
//       }
//       _inAppPurchase.purchaseStream.listen(_listenToPurchaseUpdated);
//       await _inAppPurchase.restorePurchases();
//     } catch (e) {
//       _error = 'Failed to initialize purchases: $e';
//       logger.e(_error);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     for (var purchaseDetails in purchaseDetailsList) {
//       logger.i('Purchase updated: ${purchaseDetails.status}');
//
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         _isLoading = true;
//         notifyListeners();
//         logger.i('Purchase pending: ${purchaseDetails.productID}');
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           _handlePurchaseError(purchaseDetails);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           await _handlePurchased(purchaseDetails);
//         }
//
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }
//
//   void _handlePurchaseError(PurchaseDetails purchaseDetails) {
//     _error = purchaseDetails.error?.message ?? 'Purchase error';
//     logger.e('Purchase error: $_error');
//     _isLoading = false;
//     notifyListeners(); // Add this to trigger UI update
//   }
//
//   Future<void> _handlePurchased(PurchaseDetails purchaseDetails) async {
//     try {
//       _isLoading = true; // Maintain loading during verification
//       notifyListeners();
//
//       await _verifyPurchase(purchaseDetails);
//       _purchaseSuccessController.add(null);
//       logger.i('Purchase verified successfully');
//     } catch (e) {
//       _error = 'Failed to handle purchase: $e';
//       logger.e(_error);
//     } finally {
//       _isLoading = false;
//       notifyListeners(); // Always update UI when done
//     }
//   }
//
//   Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
//     try {
//       final response = await _dioClient.dio.post(
//         '/payments/mobile/verify-purchase/',
//         data: {
//           'purchase_token':
//               purchaseDetails.verificationData.serverVerificationData,
//           'platform': Platform.isAndroid ? 'ANDROID' : 'IOS',
//         },
//       );
//       if (response.statusCode == 200) {
//         logger.i('Purchase verified');
//         await userProvider.getUserDetails();
//       } else {
//         throw Exception(
//             'Verification failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Verification failed: $e');
//     }
//   }
//
//   Future<void> buyPrediction(int predictionId) async {
//     _error = null;
//     _isLoading = true; // Add this
//     notifyListeners(); // Add this
//
//     try {
//       final product = _products.firstWhere((p) => p.id == 'buy_prediction');
//       final purchaseParam = PurchaseParam(
//         productDetails: product,
//         applicationUserName: predictionId.toString(),
//       );
//
//       await _inAppPurchase.buyConsumable(
//         purchaseParam: purchaseParam,
//         autoConsume: false,
//       );
//       logger.i('Purchase initiated for prediction $predictionId');
//     } catch (e) {
//       _error = 'Failed to initiate purchase: $e';
//       logger.e(_error);
//       _isLoading = false; // Ensure loading stops on error
//       notifyListeners();
//     }
//   }
//
//   Future<void> restorePurchases() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       await _inAppPurchase.restorePurchases();
//     } catch (e) {
//       _error = 'Failed to restore purchases: $e';
//       logger.e(_error);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   @override
//   void dispose() {
//     _purchaseSuccessController.close();
//     super.dispose();
//   }
// }
