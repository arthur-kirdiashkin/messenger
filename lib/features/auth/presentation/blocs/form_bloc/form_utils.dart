mixin FormUtils {
  static RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static bool isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static bool isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }
}
