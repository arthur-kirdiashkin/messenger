import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/repository/database_repository.dart';
import 'package:messenger/features/auth/data/repository/hive_repository.dart';
import 'package:messenger/features/auth/data/repository/supabase_repository.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_event.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SupabaseDatabaseRepository supabaseDatabaseRepository;
  final HiveRepository hiveRepository;
  final SupabaseRepository supabaseRepository;

  AuthenticationBloc({
    required this.supabaseDatabaseRepository,
    required this.hiveRepository,
    required this.supabaseRepository,
  }) : super(AuthenticationState()) {
    on<AuthenticationStarted>(_authenticationStarted);
    on<AuthenticationSignedOut>(_authenticationSignedOut);
  }
  _authenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));

    final currentUser = supabaseDatabaseRepository.getCurrentUser();

    final List<HiveUser>? hiveUsers = await hiveRepository.getHiveUsers();

    // final List<HiveUser>? hiveUsersFromDatabase =
    //     await supabaseDatabaseRepository.getHiveUsersFromDatabase();
    print(currentUser);
    // print(hiveUsers);
    // print(hiveUsersFromDatabase);
    if (hiveUsers != null && currentUser != null) {
      emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));
      final resultUser = hiveUsers
          .firstWhere((element) => element.uid == currentUser.id);
      print(state.authenticationStatus);
      emit(state.copyWith(
          authenticationStatus: AuthenticationStatus.success,
          hiveUser: resultUser));
      print(state.authenticationStatus);
    } else {
      emit(
          state.copyWith(authenticationStatus: AuthenticationStatus.notSucess));
    }
  }

  _authenticationSignedOut(
      AuthenticationSignedOut event, Emitter<AuthenticationState> emit) async {
    await supabaseRepository.signOut();
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.notSucess));
  }
}
