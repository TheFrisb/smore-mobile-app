import 'package:dio/dio.dart';

String handleDioError(DioException e) {
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

  return message;
}
