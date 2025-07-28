import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/models/prediction_response.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/models/sport/ticket.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/service/dio_client.dart';
import 'package:smore_mobile_app/utils/errors.dart';

class UpcomingPredictionsProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  static final Logger logger = Logger();

  List<PredictionResponse> _upcomingPredictions = [];
  bool _isFetchingUpcomingPredictions = false;
  String? _errorMessage;

  Future<void> fetchUpcomingPredictions(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter,
      {bool updateIsLoading = false}) async {
    logger.i(
        'Fetch upcoming predictions called with updateIsLoading=$updateIsLoading, productFilter=$productFilter, predictionObjectFilter=$predictionObjectFilter');

    if (_isFetchingUpcomingPredictions) {
      logger.i('Already fetching upcoming predictions, skipping this request.');
      return;
    }
    _errorMessage = null;
    if (updateIsLoading) {
      logger.i('Setting isFetchingUpcomingPredictions to true');
      _isFetchingUpcomingPredictions = true;
      notifyListeners();
    }

    Map<String, dynamic> queryParameters =
        _buildQueryParameters(productFilter, predictionObjectFilter);

    try {
      final response = await _dioClient.dio.get(
        '/upcoming',
        queryParameters: queryParameters,
      );
      final data = response.data;

      if (data is! List) {
        throw Exception(
            'Expected a list of predictions -- invalid response format');
      }
      _upcomingPredictions =
          data.map((json) => PredictionResponse.fromJson(json)).toList();
      logger.i('Fetched ${_upcomingPredictions.length} upcoming predictions');
    } catch (e) {
      if (e is DioException) {
        logger.e('DioException occurred: $e');
        _errorMessage = handleDioError(e);
      } else {
        _errorMessage = 'An unexpected error occurred: $e';
        logger.e('Unexpected error: $e');
      }
    } finally {
      _isFetchingUpcomingPredictions = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _buildQueryParameters(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) {
    final Map<String, dynamic> queryParameters = {};
    if (productFilter != null) {
      queryParameters['product'] = productFilter.name;
    }
    if (predictionObjectFilter != null) {
      queryParameters['obj'] = predictionObjectFilter.name;
    }
    return queryParameters;
  }

  List<PredictionResponse> get orderedUpcomingPredictions {
    return _upcomingPredictions.toList()
      ..sort((a, b) => a.datetime.compareTo(b.datetime));
  }

  List<Prediction> get orderedUpcomingPredictionsOnly {
    logger.i(_upcomingPredictions);

    return orderedUpcomingPredictions
        .where((prediction) => prediction.objectType == ObjectType.prediction)
        .map((e) => e.prediction!)
        .toList();
  }

  List<Ticket> get orderedUpcomingTicketsOnly {
    return orderedUpcomingPredictions
        .where((prediction) => prediction.objectType == ObjectType.ticket)
        .map((e) => e.ticket!)
        .toList();
  }

  bool get isFetchingUpcomingPredictions => _isFetchingUpcomingPredictions;

  String? get errorMessage => _errorMessage;
}
