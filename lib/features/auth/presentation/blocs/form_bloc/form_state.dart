import 'package:equatable/equatable.dart';

class FormsState extends Equatable {
  final String email;
  final String? displayName;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final bool isNameValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;

  FormsState({
    this.email = "example@gmail.com",
    this.password = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isFormValid = false,
    this.isLoading = false,
    this.errorMessage = "",
    this.isNameValid = true,
    this.isFormValidateFailed = false,
    this.displayName,
  });

  FormsState copyWith({
    String? email,
    String? password,
    String? displayName,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isFormValid,
    bool? isLoading,
    String? errorMessage,
    bool? isNameValid,
    bool? isAgeValid,
    bool? isFormValidateFailed,
  }) {
    return FormsState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isFormValid: isFormValid ?? this.isFormValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isNameValid: isNameValid ?? this.isNameValid,
      displayName: displayName ?? this.displayName,
      isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        isLoading,
        errorMessage,
        isNameValid,
        displayName,
        isFormValidateFailed,
      ];
}
