import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class DateGroup {
  final DateTime date;
  final List<Prediction> predictions;

  DateGroup(this.date, this.predictions);
}

class PredictionProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  static final Logger logger = Logger();

  ProductName? _currentHistoryProduct;
  List<Prediction> _predictions = [];
  bool _isLoadingUpcomingPredictions = false;
  bool _isLoadingHistoryPredictions = false;
  String? _error;
  final List<DateGroup> _dateGroups = [];
  String? _nextPageUrl;

  List<Prediction> get predictions => _predictions;

  bool get isLoadingUpcomingPredictions => _isLoadingUpcomingPredictions;

  bool get isLoadingHistoryPredictions => _isLoadingHistoryPredictions;

  String? get error => _error;

  List<DateGroup> get dateGroups => _dateGroups;

  bool get hasNextPage => _nextPageUrl != null;

  Future<void> fetchPaginatedPredictions(ProductName? productName, {bool updateIsLoading=true}) async {
    if (_isLoadingHistoryPredictions) return;


    if (updateIsLoading && _dateGroups.isNotEmpty) {
      _isLoadingHistoryPredictions = true;
    }
    logger.i(
        'Fetching paginated predictions, isLoading: $_isLoadingHistoryPredictions');

    if (productName != _currentHistoryProduct) {
      _dateGroups.clear();
      _nextPageUrl = null;
      _currentHistoryProduct = productName;
    }


    _isLoadingHistoryPredictions = true;
    _error = null;
    notifyListeners();

    try {
      String url = _nextPageUrl ?? '/history/predictions/';
      Map<String, dynamic> queryParameters =
          _nextPageUrl == null && productName != null
              ? {'product': productName.toQueryParameter()}
              : {};

      logger.i(
          'Fetching predictions from URL: $url with query: $queryParameters');
      final response =
          await _dioClient.dio.get(url, queryParameters: queryParameters);
      final data = response.data as Map<String, dynamic>;

      if (!data.containsKey('results') || data['results'] is! List) {
        throw Exception('Invalid API response: missing or invalid "results"');
      }
      final newPredictions = (data['results'] as List<dynamic>)
          .map((json) => Prediction.fromJson(json))
          .toList();
      _nextPageUrl = data['next'] is String ? data['next'] as String : null;

      _processAndAddPredictions(newPredictions);
      logger.i('Fetched ${newPredictions.length} predictions');
    } on DioException catch (e) {
      logger.e('Error fetching predictions: $e');
      _error = _handleDioError(e);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        _nextPageUrl = null;
      }
    } on Exception catch (e) {
      logger.e('Unexpected error fetching predictions: $e');
      _error = 'An unexpected error occurred while fetching predictions.';
      _nextPageUrl = null;
    } finally {
      _isLoadingHistoryPredictions = false;
      notifyListeners();
    }
  }

  void _processAndAddPredictions(List<Prediction> newPredictions) {
    for (final prediction in newPredictions) {
      final kickoffDate = prediction.match.kickoffDateTime;
      final date =
          DateTime(kickoffDate.year, kickoffDate.month, kickoffDate.day);

      final existingGroup = _dateGroups.firstWhere(
        (group) => group.date == date,
        orElse: () => DateGroup(date, []),
      );

      if (existingGroup.predictions.isEmpty) {
        _dateGroups.add(DateGroup(date, [prediction]));
      } else {
        existingGroup.predictions.add(prediction);
      }
    }
  }

  Future<void> fetchPredictions(ProductName? productName, {bool updateIsLoading=true}) async {
    if (updateIsLoading) {
      _isLoadingUpcomingPredictions = true;
    }
    _error = null;
    notifyListeners();

    Map<String, dynamic> queryParameters = {
    };
    if (productName != null) {
      queryParameters['product'] = productName.toQueryParameter();
    }

    try {
      logger.i(
          'Fetching predictions for product: ${productName?.displayName}');
      final response = await _dioClient.dio
          .get('/predictions/', queryParameters: queryParameters);
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid API response: expected a list');
      }
      _predictions = (data).map((json) => Prediction.fromJson(json)).toList();
      logger.i('Fetched ${_predictions.length} predictions');
    } on DioException catch (e) {
      logger.e('Error fetching predictions: $e');
      _error = _handleDioError(e);
    } finally {
      _isLoadingUpcomingPredictions = false;
      notifyListeners();
    }
  }

  String _handleDioError(DioException e) {
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Please check your internet connection.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server took too long to respond.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request timed out. Please try again.';
        break;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            message = 'Invalid request';
            break;
          case 401:
            message = 'Unauthorized. Please login again.';
            break;
          case 404:
            message = 'No predictions found for this date';
            break;
          case 500:
            message = 'Server error. Try again later.';
            break;
          default:
            message = 'Unexpected error: ${e.response?.statusCode}';
        }
        break;
      default:
        message = 'An unexpected error occurred: ${e.message}';
    }
    logger.e(
        'Dio error details: type=${e.type}, status=${e.response?.statusCode}, message=${e.message}');
    return message;
  }
}
