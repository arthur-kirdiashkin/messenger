import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/repository/database_repository.dart';
import 'package:messenger/features/auth/data/repository/hive_repository.dart';
import 'package:messenger/features/auth/data/repository/supabase_repository.dart';
import 'package:messenger/features/form-validation/form_bloc/form_event.dart';
import 'package:messenger/features/form-validation/form_bloc/form_state.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormBloc extends Bloc<FormEvent, FormsState> {
  final SupabaseRepository supabaseRepository;
  final SupabaseDatabaseRepository supabaseDatabaseRepository;
  final HiveRepository hiveRepository;
  // final DatabaseRepository databaseRepository;
  late SharedPreferences prefs;
  FormBloc({
    required this.hiveRepository,
    required this.supabaseDatabaseRepository,
    required this.supabaseRepository,
  }) : super(FormsState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
  }
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }

  _onEmailChanged(EmailChanged event, Emitter<FormsState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      password: event.password,
      isPasswordValid: _isPasswordValid(event.password),
    ));
  }

  _onNameChanged(NameChanged event, Emitter<FormsState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      displayName: event.displayName,
      isNameValid: _isNameValid(event.displayName),
    ));
  }

  _onFormSubmitted(FormSubmitted event, Emitter<FormsState> emit) async {
    HiveUser user = HiveUser(
        email: state.email,
        password: state.password,
        displayName: state.displayName,
        uid: '');

    if (event.value == Status.signUp) {
      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, user);
    }
  }

  _updateUIAndSignUp(
      FormSubmitted event, Emitter<FormsState> emit, HiveUser user) async {
    prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isPasswordValid(state.password) &&
            _isEmailValid(state.email) &&
            _isNameValid(state.displayName),
        isLoading: true));
    if (state.isFormValid) {
      try {
        User? authUser = await supabaseRepository.signUp(user);
        print(authUser!.lastSignInAt);
        HiveUser updatedUser = user.copyWith(
          uid: authUser.id,
          isVerified: authUser.lastSignInAt != null ? true : false,
        );
        print(updatedUser.displayName);
        await supabaseDatabaseRepository.addUser(updatedUser);
        await hiveRepository.addHiveUser(updatedUser);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on Exception catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.toString(), isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(
      FormSubmitted event, Emitter<FormsState> emit, HiveUser user) async {
    prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
        errorMessage: "",
        isFormValid:
            _isPasswordValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        User? authUser = await supabaseRepository.signIn(user);
        HiveUser updatedUser = user.copyWith(
          uid: authUser!.id,
          isVerified: authUser.confirmationSentAt != null ? true : false,
        );
        //  await supabaseDatabaseRepository.addUser(updatedUser);
        // await hiveRepository.addHiveUser(updatedUser);
        // await prefs.setBool('currentUser', true);
        print(authUser.confirmationSentAt);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on Exception catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.toString(), isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _onFormSucceeded(FormSucceeded event, Emitter<FormsState> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}
