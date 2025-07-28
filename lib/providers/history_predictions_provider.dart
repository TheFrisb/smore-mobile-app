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

class HistoryPredictionsProvider with ChangeNotifier {
  final DioClient _dioClient = DioClient();
  static final Logger logger = Logger();

  List<PredictionResponse> _historyPredictions = [];
  bool _isFetchingHistoryPredictions = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 0;
  int _totalCount = 0;
  int _pageSize = 20;
  bool _hasMorePages = false;

  List<PredictionResponse> get historyPredictions => _historyPredictions;

  bool get isFetchingHistoryPredictions => _isFetchingHistoryPredictions;

  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  int get totalCount => _totalCount;

  int get pageSize => _pageSize;

  bool get hasMorePages => _hasMorePages;

  bool get hasData => _historyPredictions.isNotEmpty;

  // Reset pagination state
  void _resetPagination() {
    _currentPage = 1;
    _totalPages = 0;
    _totalCount = 0;
    _hasMorePages = false;
  }

  // Clear all data and reset pagination
  void clearData() {
    _historyPredictions.clear();
    _resetPagination();
    _errorMessage = null;
    notifyListeners();
  }

  // Check if we should restart from page 1
  bool _shouldRestartFromPage1(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) {
    // If this is the first fetch or if filters have changed, restart from page 1
    return _historyPredictions.isEmpty || _currentPage == 1;
  }

  Future<void> fetchPaginatedHistoryPredictions(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter,
      {bool updateIsLoading = false, bool forceRefresh = false}) async {
    logger.i(
        'Fetch history predictions called with updateIsLoading=$updateIsLoading, forceRefresh=$forceRefresh, productFilter=$productFilter, predictionObjectFilter=$predictionObjectFilter, currentPage=$_currentPage');

    if (_isFetchingHistoryPredictions) {
      logger.i('Already fetching history predictions, skipping this request.');
      return;
    }

    // Determine if we should restart from page 1
    bool shouldRestart = forceRefresh ||
        _shouldRestartFromPage1(productFilter, predictionObjectFilter);

    if (shouldRestart) {
      logger.i('Restarting from page 1');
      clearData();
      _currentPage = 1;
    }

    _errorMessage = null;
    if (updateIsLoading) {
      logger.i('Setting isFetchingHistoryPredictions to true');
      _isFetchingHistoryPredictions = true;
      notifyListeners();
    }

    Map<String, dynamic> queryParameters =
        _buildQueryParameters(productFilter, predictionObjectFilter);

    try {
      final response = await _dioClient.dio.get(
        '/history/paginated-predictions/',
        queryParameters: queryParameters,
      );
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception(
            'Expected a paginated response -- invalid response format');
      }

      // Parse pagination metadata
      _totalCount = data['count'] as int? ?? 0;
      _totalPages = data['total_pages'] as int? ?? 0;
      _currentPage = data['current_page'] as int? ?? 1;
      _pageSize = data['page_size'] as int? ?? 20;
      _hasMorePages = data['next'] != null;

      // Parse results
      final results = data['results'] as List<dynamic>? ?? [];
      final newPredictions =
          results.map((json) => PredictionResponse.fromJson(json)).toList();

      if (shouldRestart) {
        // Replace existing data
        _historyPredictions = newPredictions;
        logger.i(
            'Replaced history predictions with ${newPredictions.length} items');
      } else {
        // Append new data to existing list
        _historyPredictions.addAll(newPredictions);
        logger.i(
            'Appended ${newPredictions.length} history predictions to existing list (total: ${_historyPredictions.length})');
      }

      logger.i(
          'Fetched page $_currentPage of $_totalPages (total: $_totalCount items)');
    } catch (e) {
      if (e is DioException) {
        logger.e('DioException occurred: $e');
        _errorMessage = handleDioError(e);
      } else {
        _errorMessage = 'An unexpected error occurred: $e';
        logger.e('Unexpected error: $e');
      }
    } finally {
      _isFetchingHistoryPredictions = false;
      notifyListeners();
    }
  }

  // Fetch next page
  Future<void> fetchNextPage(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) async {
    if (!_hasMorePages || _isFetchingHistoryPredictions) {
      logger.i('No more pages to fetch or already fetching');
      return;
    }

    _currentPage++;
    logger.i('Fetching next page: $_currentPage');

    await fetchPaginatedHistoryPredictions(
      productFilter,
      predictionObjectFilter,
      updateIsLoading: false,
    );
  }

  // Refresh data (restart from page 1)
  Future<void> refreshData(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) async {
    logger.i('Refreshing history predictions data');
    await fetchPaginatedHistoryPredictions(
      productFilter,
      predictionObjectFilter,
      updateIsLoading: true,
      forceRefresh: true,
    );
  }

  // Load more data (fetch next page)
  Future<void> loadMoreData(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) async {
    if (_hasMorePages && !_isFetchingHistoryPredictions) {
      await fetchNextPage(productFilter, predictionObjectFilter);
    }
  }

  Map<String, dynamic> _buildQueryParameters(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) {
    final Map<String, dynamic> queryParameters = {
      'page': _currentPage,
      'page_size': _pageSize,
    };

    if (productFilter != null) {
      queryParameters['product'] = productFilter.name;
    }
    if (predictionObjectFilter != null) {
      queryParameters['obj'] = predictionObjectFilter.name;
    }
    return queryParameters;
  }

  // Get filtered predictions based on object type
  List<PredictionResponse> getFilteredPredictions(
      PredictionObjectFilter? filter) {
    switch (filter) {
      case PredictionObjectFilter.predictions:
        return _historyPredictions
            .where(
                (prediction) => prediction.objectType == ObjectType.prediction)
            .toList();
      case PredictionObjectFilter.tickets:
        return _historyPredictions
            .where((prediction) => prediction.objectType == ObjectType.ticket)
            .toList();
      case null:
      default:
        return _historyPredictions;
    }
  }

  // Get predictions only
  List<Prediction> get historyPredictionsOnly {
    return _historyPredictions
        .where((prediction) => prediction.objectType == ObjectType.prediction)
        .map((e) => e.prediction!)
        .toList();
  }

  // Get tickets only
  List<Ticket> get historyTicketsOnly {
    return _historyPredictions
        .where((prediction) => prediction.objectType == ObjectType.ticket)
        .map((e) => e.ticket!)
        .toList();
  }
}
