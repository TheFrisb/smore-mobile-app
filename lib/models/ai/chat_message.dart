enum MessageDirection {
  INBOUND,
  OUTBOUND,
}

class ChatMessage {
  String message;
  MessageDirection direction;

  ChatMessage({
    required this.message,
    required this.direction,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        message: json['message'],
        direction: _parseDirection(json['direction']));
  }

  static MessageDirection _parseDirection(String direction) {
    switch (direction) {
      case 'inbound':
        return MessageDirection.INBOUND;
      case 'outbound':
        return MessageDirection.OUTBOUND;
      default:
        throw Exception('Unknown message direction: $direction');
    }
  }
}
