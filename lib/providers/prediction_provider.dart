// providers/prediction_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
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

  List<Prediction> _predictions = [];

  bool _isLoading = false;
  String? _error;

  List<Prediction> get predictions => _predictions;

  bool get isLoading => _isLoading;

  String? get error => _error;
  final List<DateGroup> _dateGroups = [];
  String? _nextPageUrl;

  List<DateGroup> get dateGroups => _dateGroups;

  bool get hasNextPage => _nextPageUrl != null;

  Future<void> fetchPaginatedPredictions() async {
    logger.i('Fetching paginated predictions');
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String url = _nextPageUrl ?? '/history/predictions/';
      logger.i('Fetching predictions from URL: $url');

      final response = await _dioClient.dio.get(url);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> results = data['results'];
      final newPredictions =
          results.map((json) => Prediction.fromJson(json)).toList();

      _nextPageUrl = data['next'];
      _processAndAddPredictions(newPredictions);
      logger.i('Fetched ${newPredictions.length} predictions');
    } on DioException catch (e) {
      logger.e('Error fetching predictions: $e');
      _error = _handleDioError(e);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        _nextPageUrl = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _processAndAddPredictions(List<Prediction> newPredictions) {
    for (final prediction in newPredictions) {
      final kickoffDate = prediction.match.kickoffDateTime;
      final date =
          DateTime(kickoffDate.year, kickoffDate.month, kickoffDate.day);

      if (_dateGroups.isNotEmpty && _dateGroups.last.date == date) {
        _dateGroups.last.predictions.add(prediction);
        continue;
      }

      final existingGroup = _dateGroups.firstWhere(
        (group) => group.date == date,
        orElse: () => DateGroup(date, []),
      );

      if (existingGroup.predictions.isNotEmpty) {
        existingGroup.predictions.add(prediction);
      } else {
        _dateGroups.add(DateGroup(date, [prediction]));
      }
    }
  }

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
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Please check your internet connection.';
    }

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
