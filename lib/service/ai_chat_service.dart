import 'package:smore_mobile_app/models/ai/chat_message.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class AiChatService {
  final DioClient _dioClient = DioClient();

  Future<ChatMessage> sendMessage(String message) async {
    try {
      final response = await _dioClient.dio.post(
        '/ai-assistant/send-message/',
        data: {'message': message},
      );
      return ChatMessage.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
