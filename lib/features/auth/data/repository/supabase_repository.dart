import 'package:messenger/features/auth/data/models/hive_user.dart';

import 'package:messenger/features/auth/data/repository/datasource/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseRepository {
  Future<User?> signUp(HiveUser user);

  Future<User?> signIn(HiveUser user);

  Future<void> signOut();
}

class SupabaseRepositoryImpl implements SupabaseRepository {
  SupabaseService supabaseService = SupabaseService();

  @override
  Future<User?> signIn(HiveUser user) {
    return supabaseService.signIn(user);
  }

  @override
  Future<void> signOut() {
    return supabaseService.signOut();
  }

  @override
  Future<User?> signUp(HiveUser user) {
    return supabaseService.signUp(user);
  }
}
