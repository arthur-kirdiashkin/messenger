import 'package:hive_flutter/adapters.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';

part 'chat.g.dart';

@HiveType(typeId: 2)
class Chat extends HiveObject {
  @HiveField(0)
  final List<HiveUser> users;

  @HiveField(1)
  final List<Message> messages;

  Chat({
    required this.users,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((e) => e.toJson()).toList(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      users: List.from(json['users']).map((e) => HiveUser.fromJson(e)).toList(),
      messages:
          List.from(json['messages']).map((e) => Message.fromJson(e)).toList(),
    );
  }

  Chat copyWith({
    List<HiveUser>? users,
    List<Message>? messages,
  }) {
    return Chat(
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }
}
