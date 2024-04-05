import 'package:equatable/equatable.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';

enum AuthenticationStatus {
  initial,
  loading,
  success,
  notSucess,
  logOut
}

 class AuthenticationState extends Equatable {
  final HiveUser? hiveUser;
  final AuthenticationStatus? authenticationStatus;

  const AuthenticationState({
    this.hiveUser,
    this.authenticationStatus,
  });

  AuthenticationState copyWith({
    final HiveUser? hiveUser,
    final AuthenticationStatus? authenticationStatus,
  }) {
    return AuthenticationState(
      hiveUser: hiveUser ?? this.hiveUser,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
    );
  }

  @override
  List<Object?> get props => [
        hiveUser,
        authenticationStatus,
      ];
}




