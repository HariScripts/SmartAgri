class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final DateTime createdAt;
  final String? activeFarmId;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.createdAt,
    this.activeFarmId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      activeFarmId: json['activeFarmId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'createdAt': createdAt.toIso8601String(),
      'activeFarmId': activeFarmId,
    };
  }
}
