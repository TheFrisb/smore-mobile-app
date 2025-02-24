// providers/prediction_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class PredictionProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  static final Logger logger = Logger();

  List<Prediction> _predictions = [];
  bool _isLoading = false;
  String? _error;

  List<Prediction> get predictions => _predictions;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchPredictions(DateTime date) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      logger.i('Fetching predictions for date: $date');
      final response = await _dioClient.dio.get(
        '/predictions/',
        queryParameters: {
          'date': date.toIso8601String().split('T')[0], // e.g., "2025-02-24"
        },
      );

      final List<dynamic> data = response.data;
      _predictions = data.map((json) => Prediction.fromJson(json)).toList();
      logger.i('Fetched ${_predictions.length} predictions');
    } on DioException catch (e) {
      logger.e('Error fetching predictions: $e');
      _error = _handleDioError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return 'Invalid request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 404:
        return 'No predictions found for this date';
      case 500:
        return 'Server error. Try again later.';
      default:
        return e.message ?? 'An error occurred';
    }
  }
}
