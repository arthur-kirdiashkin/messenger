import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';
import 'package:messenger/features/auth/data/repository/database_repository.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SupabaseDatabaseRepository supabaseDatabaseRepository;

  ChatBloc({required this.supabaseDatabaseRepository}) : super(ChatState()) {
    on<LoadChatEvent>(_loadChatEvent);
    on<AddMessageEvent>(_addMessageEvent);
    // on<TwoSeccondsLoadEvent>(_twoSeccondsLoadEvent);
  }

  _loadChatEvent(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: messages,
        currentUserId: currentUser!.id));
  }

  _addMessageEvent(AddMessageEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));

    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    final List<HiveUser>? hiveUsersFromDatabase =
        await supabaseDatabaseRepository.getHiveUsersFromDatabase();

    final resultUser = hiveUsersFromDatabase!
        .firstWhere((element) => element.uid == currentUser!.id);

    final randomValue = Random().nextInt(100);

    final message = await supabaseDatabaseRepository.addMessage(Message(
        userName: resultUser.displayName!,
        id: randomValue.toString(),
        profileId: currentUser!.id,
        message: event.textMessage,
        createdAt: DateTime.now().add(Duration(hours: 3))));
    print(message);

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: messages,
        currentUserId: currentUser.id));
  }

  // _twoSeccondsLoadEvent(
  //     TwoSeccondsLoadEvent event, Emitter<ChatState> emit) async {
  //   final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

  //   emit.forEach(
  //       Stream.periodic(
  //         Duration(seconds: 5),
  //         (_) {
  //           messages;
  //         },
  //       ), onData: (List<Message>? data) {
  //     return state.copyWith(messages: data, chatStatus: ChatStatus.loaded);
  //   });
  // }
}
