import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final client = Supabase.instance.client;

  Future<User?> signUp(HiveUser user) async {
    try {
      final result = await client.auth.signUp(
        password: user.password!,
        email: user.email,
      );
      return result.user;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signIn(HiveUser user) async {
    try {
      final result = await client.auth.signInWithPassword(
        password: user.password!,
        email: user.email,
      );
      return result.user;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    return await client.auth.signOut();
  }
}
