import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../service/revenuecat_service.dart';

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

class _SubscriptionButtonState extends State<SubscriptionButton> {
  bool _isLoading = false;
  static final Logger _logger = Logger();

  Future<void> _handlePurchase() async {
    if (widget.selectedPackage == null) {
      _logger.e('No package selected for purchase');
      widget.onError?.call();
      return;
    }

    if (widget.isOwned) {
      _logger.i('User already owns this subscription');
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
        _logger.i(
            'Subscription purchase successful: ${widget.selectedPackage!.identifier}');
        widget.onSuccess?.call();
      } else {
        _logger.e(
            'Subscription purchase failed: ${consumablePurchaseResult.errorMessage}');
        widget.onError?.call();
      }
    } catch (e) {
      _logger.e('Purchase error: $e');
      widget.onError?.call();
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    return Theme.of(context).primaryColor;
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
            : Text(
                _buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
