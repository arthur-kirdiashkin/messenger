import 'package:hive_flutter/adapters.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String profileId;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(5)
  final String userName;

  Message({
    this.id,
    required this.userName,
    required this.profileId,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'id': id,
      'profile_id': profileId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      userName: json['user_name'],
      id: json['id'],
      profileId: json['profile_id'],
      message: json['message'],
      createdAt: DateTime.parse(
        json['created_at'],
      ),
    );
  }
}
