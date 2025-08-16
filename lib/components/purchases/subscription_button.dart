import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../service/revenuecat_service.dart';
import '../../utils/revenuecat_error_mixin.dart';

class SubscriptionButton extends StatefulWidget {
  final Package? selectedPackage;
  final bool isOwned;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const SubscriptionButton({
    super.key,
    required this.selectedPackage,
    this.isOwned = false,
    this.onSuccess,
    this.onError,
  });

  @override
  State<SubscriptionButton> createState() => _SubscriptionButtonState();
}

class _SubscriptionButtonState extends State<SubscriptionButton>
    with RevenueCatErrorMixin {
  bool _isLoading = false;

  Future<void> _handlePurchase() async {
    if (widget.selectedPackage == null) {
      logError('No package selected for purchase');
      widget.onError?.call();
      return;
    }

    if (widget.isOwned) {
      logInfo('User already owns this subscription');
      widget.onSuccess?.call();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      ConsumablePurchaseResult consumablePurchaseResult =
          await RevenueCatService()
              .purchaseSubscription(widget.selectedPackage!);

      if (consumablePurchaseResult.success) {
        logInfo(
            'Subscription purchase successful: ${widget.selectedPackage!.identifier}');
        showSuccessMessage('Subscription purchased successfully!');
        widget.onSuccess?.call();
      } else {
        logError(
            'Subscription purchase failed: ${consumablePurchaseResult.errorMessage}');
        showErrorMessage(
            'Purchase failed: ${consumablePurchaseResult.errorMessage}');
        widget.onError?.call();
      }
    } catch (e, stackTrace) {
      handleRevenueCatError(
        e,
        stackTrace,
        productId: widget.selectedPackage?.identifier,
        operation: 'subscription_purchase',
        onError: widget.onError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String get _buttonText {
    if (widget.isOwned) {
      return 'Already Subscribed';
    }
    return 'Continue';
  }

  Color get _buttonColor {
    if (widget.isOwned) {
      return Colors.grey;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handlePurchase,
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(_buttonText),
        ));
  }
}
