import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';
import 'package:messenger/features/auth/data/repository/database_repository.dart';
import 'package:messenger/features/auth/data/repository/hive_repository.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:async/async.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SupabaseDatabaseRepository supabaseDatabaseRepository;
  final HiveRepository hiveRepository;

  ChatBloc(
      {required this.supabaseDatabaseRepository, required this.hiveRepository})
      : super(ChatState()) {
    on<LoadChatEvent>(_loadChatEvent);
    on<AddMessageEvent>(_addMessageEvent);
    on<TwoSeccondsLoadEvent>(_twoSeccondsLoadEvent);
  }

  _loadChatEvent(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    final messagesFromHive = await hiveRepository.getHiveMessages();

    if (messagesFromHive != null && messagesFromHive.isNotEmpty) {
      for (Message i in messages!) {
        if (!messagesFromHive.contains(i)) {
          await hiveRepository.addMessage(i);
        }
      }
    }

    final newMessages = await hiveRepository.getHiveMessages();
    final List<Message>? twoLastMessage = [];

    if (newMessages != null && newMessages.isNotEmpty) {
      newMessages.sort((a, b) => a.createdAt.isBefore(b.createdAt) ? -1 : 1);
      print(messagesFromHive);

      twoLastMessage!.add(newMessages[newMessages.length - 2]);

      twoLastMessage.add(newMessages.last);
    }

    print(messagesFromHive);

    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    emit(state.copyWith(chatStatus: ChatStatus.loading));

    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: twoLastMessage,
        currentUserId: currentUser!.id));

    await Future.delayed(Duration(seconds: 3));

    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: messages,
        currentUserId: currentUser.id));
  }

  _addMessageEvent(AddMessageEvent event, Emitter<ChatState> emit) async {
    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    final List<HiveUser>? hiveUsersFromDatabase =
        await supabaseDatabaseRepository.getHiveUsersFromDatabase();

    final resultUser = hiveUsersFromDatabase!
        .firstWhere((element) => element.uid == currentUser!.id);

    final randomValue = Random().nextInt(100);

    final messageInHive = await hiveRepository.addMessage(Message(
        id: randomValue.toString(),
        userName: resultUser.displayName!,
        profileId: currentUser!.id,
        message: event.textMessage,
        createdAt: DateTime.now()));

    final message = await supabaseDatabaseRepository.addMessage(Message(
        userName: resultUser.displayName!,
        id: randomValue.toString(),
        profileId: currentUser!.id,
        message: event.textMessage,
        createdAt: DateTime.now()));

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    // if (messageInHive!.userName != messages!.last.userName) {
    //   hiveRepository.addMessage(messages.last);
    // }

    // if (messageInHive.userName != messages[messages.length - 2].userName) {
    //   hiveRepository.addMessage(messages[messages.length - 2]);
    // }

    if (messageInHive != messages!.last) {
      hiveRepository.addMessage(messages.last);
    }

    if (messageInHive != messages[messages.length - 2]) {
      hiveRepository.addMessage(messages[messages.length - 2]);
    }

    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: messages,
        currentUserId: currentUser.id));
  }

  _twoSeccondsLoadEvent(
      TwoSeccondsLoadEvent event, Emitter<ChatState> emit) async {
    final messages = supabaseDatabaseRepository.getStreamMessages();
    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    await emit.forEach(messages, onData: (data) {
      return state.copyWith(
          chatStatus: ChatStatus.loaded,
          messages: data,
          currentUserId: currentUser!.id);
    }).catchError(onError);
  }
}
