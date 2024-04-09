import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/repository/database_repository.dart';
import 'package:messenger/features/auth/data/repository/hive_repository.dart';
import 'package:messenger/features/auth/data/repository/supabase_repository.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_event.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_state.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormBloc extends Bloc<FormEvent, FormsState> {
  final SupabaseRepository supabaseRepository;
  final SupabaseDatabaseRepository supabaseDatabaseRepository;
  final HiveRepository hiveRepository;
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
  }

  _onEmailChanged(EmailChanged event, Emitter<FormsState> emit) {
    emit(state.copyWith(
      isFormValid: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: FormUtils.isEmailValid(event.email),
    ));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsState> emit) {
    emit(state.copyWith(
      errorMessage: "",
      password: event.password,
      isPasswordValid: FormUtils.isPasswordValid(event.password),
    ));
  }

  _onNameChanged(NameChanged event, Emitter<FormsState> emit) {
    emit(state.copyWith(
      isFormValidateFailed: false,
      errorMessage: "",
      displayName: event.displayName,
      isNameValid: FormUtils.isNameValid(event.displayName),
    ));
  }

  _onFormSubmitted(FormSubmitted event, Emitter<FormsState> emit) async {
    HiveUser user = HiveUser(
        email: state.email,
        password: state.password,
        displayName: state.displayName,
        uid: '');

    if (event.value == FormStatus.signUp) {
      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == FormStatus.signIn) {
      await _authenticateUser(event, emit, user);
    }
  }

  _updateUIAndSignUp(
      FormSubmitted event, Emitter<FormsState> emit, HiveUser user) async {
    prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: FormUtils.isPasswordValid(state.password) &&
            FormUtils.isEmailValid(state.email) &&
            FormUtils.isNameValid(state.displayName),
        isLoading: true));
    if (state.isFormValid) {
      try {
        User? authUser = await supabaseRepository.signUp(user);
        HiveUser updatedUser = user.copyWith(
          uid: authUser!.id,
          isVerified: authUser.lastSignInAt != null ? true : false,
        );
        await supabaseDatabaseRepository.addUser(updatedUser);
        await hiveRepository.addHiveUser(updatedUser);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(
              isLoading: state.isLoading, errorMessage: state.errorMessage));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on Exception catch (e) {
        emit(state.copyWith(
            isLoading: state.isLoading,
            errorMessage: e.toString(),
            isFormValid: false));
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
        isFormValid: FormUtils.isPasswordValid(state.password) &&
            FormUtils.isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        User? authUser = await supabaseRepository.signIn(user);
        HiveUser updatedUser = user.copyWith(
          uid: authUser!.id,
          isVerified: authUser.confirmationSentAt != null ? true : false,
        );
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
}
