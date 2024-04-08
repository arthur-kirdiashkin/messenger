import 'package:hive/hive.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';

abstract class HiveRepository {
  Future<HiveUser?> addHiveUser(HiveUser hiveUser);

  Future<List<HiveUser>?> getHiveUsers();

  Future<bool> deleteHiveUser(int id);

  void openBoxUsers();

  void openBoxMessages();

  Future<Message?> addMessage(Message message);

  Future<List<Message>?> getHiveMessages();
}

class HiveRepositoryImpl implements HiveRepository {
  @override
  Future<HiveUser?> addHiveUser(HiveUser hiveUser) async {
    final userBox = await openBoxUsers();

    userBox.put(hiveUser.uid, hiveUser);

    // print(hiveUser);
    return hiveUser;
  }

  @override
  Future<List<HiveUser>?> getHiveUsers() async {
    List<HiveUser> users = [];
    final userBox = await openBoxUsers();

    for (var i in userBox.values) {
      if (i.runtimeType == HiveUser) {
        users.add(i);
      }
    }
    // print(userBox.values);
    return users;
  }

  @override
  Future<Box> openBoxUsers() async {
    // Hive.deleteBoxFromDisk('HiveUser');
    return await Hive.openBox('HiveUser');
  }

  @override
  Future<Box> openBoxMessages() async {
    // Hive.deleteBoxFromDisk('HiveMessages');
    return await Hive.openBox('HiveMessages');
  }

  @override
  Future<bool> deleteHiveUser(int id) async {
    final todoBox = await openBoxUsers();
    todoBox.delete(id);
    return true;
  }

  @override
  Future<Message?> addMessage(Message message) async {
    final openMessages = await openBoxMessages();

    openMessages.put(message.id, message);

    return message;
  }

  @override
  Future<List<Message>?> getHiveMessages() async {
    List<Message> messages = [];
    final openMessagesBox = await openBoxMessages();

    for (var i in openMessagesBox.values) {
      if (i.runtimeType == Message) {
        messages.add(i);
      }
    }

    return messages;
  }
}
