import 'package:smore_mobile_app/models/faq_item.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class FaqService {
  static final FaqService _instance = FaqService._internal();

  factory FaqService() => _instance;

  FaqService._internal();

  final DioClient _dioClient = DioClient();
  List<FrequentlyAskedQuestion>? _cachedFaqItems;

  Future<List<FrequentlyAskedQuestion>> getFaqItems() async {
    if (_cachedFaqItems != null) return _cachedFaqItems!;

    try {
      final response = await _dioClient.dio.get('/frequently-asked-questions/');
      if (response.statusCode != 200) throw Exception('Failed to load FAQs');

      _cachedFaqItems = (response.data as List)
          .map((item) => FrequentlyAskedQuestion.fromJson(item))
          .toList();
      return _cachedFaqItems!;
    } catch (e) {
      throw Exception('Failed to load FAQs: $e');
    }
  }
}
