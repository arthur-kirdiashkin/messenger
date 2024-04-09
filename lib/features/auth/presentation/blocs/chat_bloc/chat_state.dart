import 'package:equatable/equatable.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';


enum ChatStatus {
  initial,
  loaded,
  loading,
  error,
}

class ChatState extends Equatable {
  final ChatStatus? chatStatus;
  final List<Message>? messages;
  final List<HiveUser>? users;
  final String? currentUserId;

  const ChatState({
    this.currentUserId,
     this.chatStatus,
     this.users,
     this.messages,
  });

  ChatState copyWith({
    final String? currentUserId,
    final List<Message>? messages,
    final List<HiveUser>? users,
    final ChatStatus? chatStatus,
  }) {
    return ChatState(
      currentUserId: currentUserId ?? this.currentUserId,
      chatStatus: chatStatus ?? this.chatStatus,
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }

  @override

  List<Object?> get props => [
        currentUserId,
        messages,
        users,
        chatStatus,
      ];
}
