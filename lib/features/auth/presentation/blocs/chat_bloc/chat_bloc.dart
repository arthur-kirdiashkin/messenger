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
    on<StreamLoadEvent>(_twoSeccondsLoadEvent);
  }

  _loadChatEvent(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));

    final List<Message> chatMessages = [];

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    final messagesFromHive = await hiveRepository.getHiveMessages();

    if (messagesFromHive != null || messagesFromHive!.isNotEmpty) {
      for (Message i in messages!) {
        if (!messagesFromHive.contains(i)) {
          await hiveRepository.addMessage(i);
        }
      }
      messagesFromHive.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    if (messages == null || messages.isEmpty) {
      chatMessages.addAll(messagesFromHive);
    } else {
      chatMessages.addAll(messages);
    }

    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    emit(state.copyWith(chatStatus: ChatStatus.loading));
    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: messages,
        currentUserId: currentUser!.id));
  }

  _addMessageEvent(AddMessageEvent event, Emitter<ChatState> emit) async {
    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    final List<HiveUser>? hiveUsersFromDatabase =
        await supabaseDatabaseRepository.getHiveUsersFromDatabase();

    final resultUser = hiveUsersFromDatabase!
        .firstWhere((element) => element.uid == currentUser!.id);

    final randomValue = Random().nextInt(100);

    final dateNow = DateTime.now();

     await supabaseDatabaseRepository.addMessage(Message(
        userName: resultUser.displayName!,
        id: randomValue.toString(),
        profileId: currentUser!.id,
        message: event.textMessage,
        createdAt: dateNow));

     await hiveRepository.addMessage(Message(
        id: randomValue.toString(),
        userName: resultUser.displayName!,
        profileId: currentUser.id,
        message: event.textMessage,
        createdAt: dateNow));

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    emit(state.copyWith(
        chatStatus: ChatStatus.loaded,
        messages: messages,
        currentUserId: currentUser.id));
  }

  _twoSeccondsLoadEvent(StreamLoadEvent event, Emitter<ChatState> emit) async {
    final messagesStream = supabaseDatabaseRepository.getStreamMessages();
    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    final messages = await supabaseDatabaseRepository.getMessagesFromDatabase();

    final messagesFromHive = await hiveRepository.getHiveMessages();

    if (messagesFromHive != null || messagesFromHive!.isNotEmpty) {
      for (Message i in messages!) {
        if (!messagesFromHive.contains(i)) {
          await hiveRepository.addMessage(i);
        }
      }
      messagesFromHive.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      // messagesFromHive.sort((a, b) => a.createdAt.isBefore(b.createdAt) ? 0 : 1);
      // chatMessages.reversed;
    }

    await emit.forEach(messagesStream, onData: (data) {
      if (data == null || data.isEmpty) {
        messagesFromHive.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return state.copyWith(
            chatStatus: ChatStatus.loaded,
            messages: messagesFromHive,
            currentUserId: currentUser!.id);
      } else {
        for (Message i in data) {
          if (!messagesFromHive.contains(i)) {
            hiveRepository.addMessage(i);
          }
        }

        return state.copyWith(
            chatStatus: ChatStatus.loaded,
            messages: data,
            currentUserId: currentUser!.id);
      }
    }).catchError(onError);
  }
}
