import 'package:equatable/equatable.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';

abstract class ChatEvent extends Equatable {}

class LoadChatEvent extends ChatEvent {
  LoadChatEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddMessageEvent extends ChatEvent {
  final String textMessage;

  AddMessageEvent({
    required this.textMessage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        textMessage,
      ];
}

class TwoSeccondsLoadEvent extends ChatEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
