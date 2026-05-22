class NotificationModel {
  final String id;
  final String message;
  final String type; // 'alert', 'info', 'warning'
  final String farmId;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.type,
    required this.farmId,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      farmId: json['farmId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type,
      'farmId': farmId,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
