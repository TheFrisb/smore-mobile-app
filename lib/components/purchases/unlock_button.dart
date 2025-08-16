import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';

import '../../app_colors.dart';
import '../../providers/user_provider.dart';
import '../../service/consumable_purchases_verifier.dart';
import '../../utils/revenuecat_error_mixin.dart';

class UnlockButton extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final int objectId;
  final ConsumableIdentifiers consumableIdentifier;

  const UnlockButton({
    super.key,
    required this.onSuccess,
    required this.onError,
    required this.objectId,
    required this.consumableIdentifier,
  });

  @override
  State<UnlockButton> createState() => _UnlockButtonState();
}

class _UnlockButtonState extends State<UnlockButton>
    with RevenueCatErrorMixin {
  bool _isLoading = false;

  UserProvider get userProvider =>
      Provider.of<UserProvider>(context, listen: false);

  ConsumablePurchasesVerifier get consumablePurchasesVerifier =>
      ConsumablePurchasesVerifier();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.shade500,
            AppColors.secondary.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.shade500.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handlePurchase,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Text(
                    'Unlock Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (!_isLoading) const SizedBox(width: 8),
                if (!_isLoading)
                  const Icon(
                    LucideIcons.lock,
                    color: Colors.white,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      ConsumablePurchaseResult purchaseResult = await RevenueCatService()
          .purchaseConsumable(widget.consumableIdentifier);

      if (purchaseResult.success) {
        logInfo('Consumable purchase successful: ${widget.consumableIdentifier.value}');
        
        await consumablePurchasesVerifier.verifyConsumablePurchase(
            widget.consumableIdentifier,
            purchaseResult.transactionId!,
            widget.objectId);
        await userProvider.getUserDetails();

        showSuccessMessage('Purchase successful!');
        widget.onSuccess?.call();
      } else {
        logError('Consumable purchase failed: ${purchaseResult.errorMessage}');
        showErrorMessage('Purchase failed: ${purchaseResult.errorMessage}');
        widget.onError?.call();
      }
    } catch (e, stackTrace) {
      handleRevenueCatError(
        e,
        stackTrace,
        productId: widget.consumableIdentifier.value,
        operation: 'consumable_purchase',
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
}
