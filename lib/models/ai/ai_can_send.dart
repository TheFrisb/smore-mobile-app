class AiCanSend {
  final bool canSend;
  final int count;

  AiCanSend({
    required this.canSend,
    required this.count,
  });

  factory AiCanSend.fromJson(Map<String, dynamic> json) {
    return AiCanSend(canSend: json['can_send'], count: json['count']);
  }
}
