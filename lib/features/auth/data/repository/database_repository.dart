import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';
import 'package:messenger/features/auth/data/repository/datasource/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseDatabaseRepository {

  User? getCurrentUser();

  Future<Message?> addMessage(Message message);

  Future<List<Message>?> getMessagesFromDatabase();

  Future<HiveUser?> addUser(HiveUser user); 

  Future <List<HiveUser>?> getHiveUsersFromDatabase();
}


class SupabaseDatabaseRepositoryImpl implements SupabaseDatabaseRepository{

  SupabaseDatabaseService supabaseDatabaseService = SupabaseDatabaseService();

  @override
  Future<HiveUser?> addUser(HiveUser user) {
    return supabaseDatabaseService.addUser(user);
  }
  
  @override
  Future<List<HiveUser>?> getHiveUsersFromDatabase() {
    return supabaseDatabaseService.getHiveUsersFromDatabase();
  }
  
  @override
  Future<Message?> addMessage(Message message)  {
   return supabaseDatabaseService.addMessage(message);
  }
  
  @override
  Future<List<Message>?> getMessagesFromDatabase() {
    return supabaseDatabaseService.getMessagesFromDatabase();
  }
  
  @override
  User? getCurrentUser() {
    return supabaseDatabaseService.getCurrentUser();
  }

}