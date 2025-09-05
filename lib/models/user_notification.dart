enum NotificationIcon { SOCCER, BASKETBALL, TROPHY, CHECKMARK, XMARK }

class UserNotification {
  final int _id;
  final String _title;
  final String _message;
  final bool _isRead;
  final bool _isImportant;
  final NotificationIcon? _icon;
  final DateTime _createdAt;

  UserNotification({
    required int id,
    required String title,
    required String message,
    required bool isRead,
    required bool isImportant,
    NotificationIcon? icon,
    required DateTime createdAt,
  })  : _id = id,
        _title = title,
        _message = message,
        _isRead = isRead,
        _isImportant = isImportant,
        _icon = icon,
        _createdAt = createdAt;

  // Getter methods for external access
  int get id => _id;

  String get title => _title;

  String get message => _message;

  bool get isRead => _isRead;

  bool get isImportant => _isImportant;

  NotificationIcon? get icon => _icon;

  DateTime get createdAt => _createdAt;

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    NotificationIcon? icon;
    
    if (json['icon'] != null) {
      try {
        icon = NotificationIcon.values.firstWhere(
          (e) => e.name == json['icon'],
        );
      } catch (e) {
        // If we can't match the icon to the enum, set it to null
        icon = null;
      }
    }
    
    return UserNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      isImportant: json['is_important'] ?? false,
      icon: icon,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
