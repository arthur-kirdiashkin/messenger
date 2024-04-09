import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseService {
  final client = Supabase.instance.client;

  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  Future<HiveUser?> addUser(HiveUser user) async {
    await client.from('users').insert(user.toJson());
  }

  Future<List<HiveUser>?> getHiveUsersFromDatabase() async {
    final res = await client.from('users').select();
    List<HiveUser> databaseUsers = [];
    for (Map<String, dynamic> i in res) {
      final user = HiveUser.fromJson(i);
      databaseUsers.add(user);
    }

    return databaseUsers;
  }

  Future<Message?> addMessage(Message message) async {
    await client.from('message').insert(message.toJson());
  }

  Future<List<Message>?> getMessagesFromDatabase() async {
    final resMessages = await client.from('message').select();

    List<Message> messages = [];

    for (Map<String, dynamic> i in resMessages) {
      final message = Message.fromJson(i);

      messages.add(message);
    }

    return messages;
  }

  Stream<List<Message>?> getStreamMessages() {
    final messagesStream = client.from('message').stream(primaryKey: [
      'created_at'
    ]).map((maps) => maps.map((map) => Message.fromJson(map)).toList());
    return messagesStream;
  }
}
