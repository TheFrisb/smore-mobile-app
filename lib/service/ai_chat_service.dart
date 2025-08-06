import 'package:logger/logger.dart';
import 'package:smore_mobile_app/models/ai/ai_can_send.dart';
import 'package:smore_mobile_app/models/ai/chat_message.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class AiChatService {
  final DioClient _dioClient = DioClient();
  static final Logger _logger = Logger();

  Future<ChatMessage> sendMessage(String message, String timezone) async {
    try {
      _logger.i("Sending AI message with timezone: $timezone");
      final response = await _dioClient.dio.post(
        '/ai-assistant/send-message/',
        data: {
          'message': message,
          'timezone': timezone,
        },
      );
      _logger.i("AI message sent successfully");
      return ChatMessage.fromJson(response.data);
    } catch (e) {
      _logger.e("Failed to send AI message: $e");
      throw Exception('Failed to send message: $e');
    }
  }

  Future<AiCanSend> getCanSend() async {
    try {
      _logger.i("Checking if AI can send...");
      final response = await _dioClient.dio.get('/ai-assistant/can-send/');
      _logger.i("AI can send response received: ${response.data}");
      final result = AiCanSend.fromJson(response.data);
      _logger.i(
          "Parsed AI can send: count=${result.count}, canSend=${result.canSend}");
      return result;
    } catch (e) {
      _logger.e("Failed to check if AI can send: $e");
      throw Exception('Failed to check if AI can send: $e');
    }
  }

  ChatMessage createMessage({
    required String message,
    required MessageDirection direction,
  }) {
    return ChatMessage(
      message: message,
      direction: direction,
    );
  }
}
