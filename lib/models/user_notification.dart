class UserNotification {
  final int _id;
  final String _title;
  final String _message;
  final bool _isRead;
  final DateTime _createdAt;

  UserNotification({
    required int id,
    required String title,
    required String message,
    required bool isRead,
    required DateTime createdAt,
  })  : _id = id,
        _title = title,
        _message = message,
        _isRead = isRead,
        _createdAt = createdAt;


  // Getter methods for external access
  int get id => _id;

  String get title => _title;

  String get message => _message;

  bool get isRead => _isRead;

  DateTime get createdAt => _createdAt;

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
