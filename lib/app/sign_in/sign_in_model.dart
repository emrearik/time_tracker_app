import 'package:flutter/cupertino.dart';
import 'package:flutter_time_tracker_app/app/sign_in/email_sign_in_page.dart';
import 'package:flutter_time_tracker_app/app/sign_in/validators.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';

class SignInModel with ChangeNotifier, EmailAndPasswordValidators {
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool submitted;
  bool isLoading;

  SignInModel(
      {required this.auth,
      this.email = "",
      this.password = "",
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? submitted,
      bool? isLoading}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.submitted = submitted ?? this.submitted;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: "",
        password: "",
        formType: formType,
        isLoading: false,
        submitted: false);
    print(formType.toString());
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn ? "Login" : "Register";
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have an account? Login";
  }

  bool get canSubmit {
    return !isLoading &&
        emailValidator.isValid(email) &&
        passwordValidator.isValid(password);
  }

  String? get emailErrorText {
    bool showErrorText = submitted && emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);
}
