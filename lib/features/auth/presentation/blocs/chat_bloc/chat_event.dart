import 'package:equatable/equatable.dart';


abstract class ChatEvent extends Equatable {}

class LoadChatEvent extends ChatEvent {
  LoadChatEvent();

  @override

  List<Object?> get props => [];
}

class AddMessageEvent extends ChatEvent {
  final String textMessage;

  AddMessageEvent({
    required this.textMessage,
  });

  @override

  List<Object?> get props => [
        textMessage,
      ];
}

class StreamLoadEvent extends ChatEvent {
  @override

  List<Object?> get props => [];
}
