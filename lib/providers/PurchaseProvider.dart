import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

import '../service/revenuecat_service.dart';

class PurchaseProvider with ChangeNotifier {
  static final Logger logger = Logger();
  bool _isPurchasingDailyOffer = false;
  int? _purchasingPredictionId;
  int? _purchasingTicketId;

  bool get isPurchasingDailyOffer => _isPurchasingDailyOffer;

  int? get purchasingPredictionId => _purchasingPredictionId;

  int? get purchasingTicketId => _purchasingTicketId;

  void setPurchasingDailyOffer(bool value) {
    _isPurchasingDailyOffer = value;
    notifyListeners();
  }

  void setPurchasingPredictionId(int? id) {
    _purchasingPredictionId = id;
    notifyListeners();
  }

  void setPurchasingTicketId(int? id) {
    _purchasingTicketId = id;
    notifyListeners();
  }

  Future<void> purchaseDailyOffer() async {
    logger.i('Starting purchase of daily offer');
    setPurchasingDailyOffer(true);

    ConsumablePurchaseResult purchaseResult = await RevenueCatService()
        .purchaseConsumable(ConsumableIdentifiers.dailyOffer);

    logger.i('Daily offer purchased successfully');
    setPurchasingDailyOffer(false);
  }
}
