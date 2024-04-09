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
  final String? errorMessage;

  const ChatState({
    this.errorMessage,
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
    final String? errorMessage
  }) {
    return ChatState(
      currentUserId: currentUserId ?? this.currentUserId,
      chatStatus: chatStatus ?? this.chatStatus,
      users: users ?? this.users,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override

  List<Object?> get props => [
        currentUserId,
        messages,
        users,
        chatStatus,
        errorMessage,
      ];
}
