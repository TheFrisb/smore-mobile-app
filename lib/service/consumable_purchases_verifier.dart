import 'package:logger/logger.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';

import 'dio_client.dart';

class ConsumablePurchasesVerifier {
  final DioClient _dioClient;
  static final Logger _logger = Logger();

  ConsumablePurchasesVerifier() : _dioClient = DioClient();

  Future<bool> verifyConsumablePurchase(ConsumableIdentifiers identifier,
      String transactionId, int objectId) async {
    _logger.i(
        'Verifying single ticket purchase: identifier=$identifier, transactionId=$transactionId, objectId=$objectId');

    Map<String, dynamic> data = {
      'original_transaction_id': transactionId,
      'purchased_object_id': objectId,
      'consumable_type': identifier.value
    };

    try {
      final response = await _dioClient.dio.post(
        '/payments/revenuecat/consumable/consume/',
        data: data,
      );

      if (response.statusCode == 204) {
        _logger.i('Consumable purchase verified successfully');
        return true;
      } else {
        throw Exception('Failed to verify single ticket purchase');
      }
    } catch (e) {
      _logger.e('Error verifying single ticket purchase: $e');
      return false;
    }
  }
}
