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
  bool _isLoadingMore = false; // Add this field

  List<PredictionResponse> get historyPredictions => _historyPredictions;

  bool get isFetchingHistoryPredictions => _isFetchingHistoryPredictions;

  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  int get totalCount => _totalCount;

  int get pageSize => _pageSize;

  bool get hasMorePages => _hasMorePages;

  bool get hasData => _historyPredictions.isNotEmpty;

  bool get isLoadingMore => _isLoadingMore; // Add this getter

  // Helper methods for UI state
  bool get shouldShowLoadingAtBottom => (isLoadingMore ||
      (isFetchingHistoryPredictions && historyPredictions.isNotEmpty));

  bool get shouldShowEndMessage =>
      !hasMorePages &&
      historyPredictions.isNotEmpty &&
      !isFetchingHistoryPredictions;

  bool get shouldShowScrollHint =>
      hasMorePages && !isLoadingMore && !isFetchingHistoryPredictions;

  // Reset pagination state
  void _resetPagination() {
    _currentPage = 1;
    _totalPages = 0;
    _totalCount = 0;
    _hasMorePages = false;
    _isLoadingMore = false; // Add this
  }

  // Clear all data and reset pagination
  void clearData() {
    _historyPredictions.clear();
    _resetPagination();
    _errorMessage = null;
    notifyListeners();
  }

  // Check if we should restart from page 1
  bool _shouldRestartFromPage1() {
    // Only restart if this is the first fetch (empty list)
    return _historyPredictions.isEmpty;
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
    bool shouldRestart = forceRefresh || _shouldRestartFromPage1();

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

      // Parse pagination metadata from API response
      _totalCount = data['count'] as int? ?? 0;
      _totalPages = data['total_pages'] as int? ?? 0;
      // Only update current page from server if we're starting fresh
      if (shouldRestart) {
        _currentPage = data['current_page'] as int? ?? 1;
      }
      _pageSize = data['page_size'] as int? ?? 20;
      _hasMorePages = data['next'] != null;
      logger.i(
          'Pagination state: page=$_currentPage/$_totalPages, hasMore=$_hasMorePages, count=$_totalCount, next=${data['next']}');

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
      _isLoadingMore = false; // Add this
      notifyListeners();
    }
  }

  // Fetch next page
  Future<void> fetchNextPage(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) async {
    if (!_hasMorePages || _isFetchingHistoryPredictions || _isLoadingMore) {
      logger.i(
          'No more pages to fetch, already fetching, or loading more. hasMorePages=$_hasMorePages, isFetching=$_isFetchingHistoryPredictions, isLoadingMore=$_isLoadingMore');
      return;
    }

    // Check if we're trying to fetch beyond the total pages
    if (_currentPage >= _totalPages && _totalPages > 0) {
      logger.i(
          'Already at or beyond total pages ($_currentPage >= $_totalPages)');
      _hasMorePages = false;
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    // Store the next page number but don't increment _currentPage yet
    final nextPage = _currentPage + 1;
    logger.i('Fetching next page: $nextPage (current: $_currentPage)');

    // Temporarily increment _currentPage for the API call
    final originalPage = _currentPage;
    _currentPage = nextPage;

    try {
      await fetchPaginatedHistoryPredictions(
        productFilter,
        predictionObjectFilter,
        updateIsLoading: false,
      );
      // If successful, _currentPage is already updated
      logger.i('Successfully fetched page $nextPage');
    } catch (e) {
      // If failed, restore original page
      _currentPage = originalPage;
      _isLoadingMore = false;
      logger.e(
          'Failed to fetch page $nextPage, restored to page $originalPage: $e');
      rethrow;
    }
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

  // Refresh data without clearing existing predictions (for pull-to-refresh)
  Future<void> refreshDataKeepExisting(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter,
      {bool updateIsLoading = true}) async {
    logger.i('Refreshing history predictions data while keeping existing data');
    
    if (_isFetchingHistoryPredictions) {
      logger.i('Already fetching history predictions, skipping this request.');
      return;
    }

    // Reset pagination state but keep existing data
    _currentPage = 1;
    _totalPages = 0;
    _totalCount = 0;
    _hasMorePages = false;
    _isLoadingMore = false;
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

      // Parse pagination metadata from API response
      _totalCount = data['count'] as int? ?? 0;
      _totalPages = data['total_pages'] as int? ?? 0;
      _currentPage = data['current_page'] as int? ?? 1;
      _pageSize = data['page_size'] as int? ?? 20;
      _hasMorePages = data['next'] != null;
      logger.i(
          'Pagination state: page=$_currentPage/$_totalPages, hasMore=$_hasMorePages, count=$_totalCount, next=${data['next']}');

      // Parse results and replace existing data
      final results = data['results'] as List<dynamic>? ?? [];
      final newPredictions =
          results.map((json) => PredictionResponse.fromJson(json)).toList();

      _historyPredictions = newPredictions;
      logger.i(
          'Replaced history predictions with ${newPredictions.length} items (kept existing during refresh)');

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
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Load more data (fetch next page)
  Future<void> loadMoreData(ProductName? productFilter,
      PredictionObjectFilter? predictionObjectFilter) async {
    if (_hasMorePages && !_isFetchingHistoryPredictions && !_isLoadingMore) {
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
      queryParameters['filter'] = productFilter.name;
    }
    if (predictionObjectFilter != null) {
      queryParameters['obj'] = predictionObjectFilter.name;
    }

    // log the query parameters
    logger.i('Query parameters for history predictions: $queryParameters');

    return queryParameters;
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
