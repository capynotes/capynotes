import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/auth/login_model.dart';
import '../../../model/user/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../translations/locale_keys.g.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.service) : super(LoginInitial()) {
    getEmailPref().then((value) => emailController.text = value);
    getPasswordPref().then((value) => passwordController.text = value);
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginModel loginModel = LoginModel();
  AuthService service;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  bool rememberMe = false;
  bool isObscure = true;

  Future<void> amplifyLoginUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      await _amplifyHandleLoginResult(result);
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
  }

  Future<void> _amplifyHandleLoginResult(SignInResult result) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.done:
        safePrint('Sign in is complete');
        break;
      default:
        safePrint('Sign in not complete: ${result.nextStep.signInStep}');
    }
  }

  Future<void> login() async {
    emit(LoginLoading());
    loginModel.email = emailController.text;
    loginModel.password = passwordController.text;
    UserModel? response = await service.login(loginModel);
    if (response != null) {
      await amplifyLoginUser(emailController.text, passwordController.text);
      if (rememberMe) {
        setEmailPref();
        setPasswordPref();
      } else {
        clearSavedPrefs();
      }
      setRememberMe();
      emit(LoginSuccess(
          LocaleKeys.dialogs_success_dialogs_login_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_login_success_description.tr()));
    } else {
      emit(LoginError(LocaleKeys.dialogs_error_dialogs_login_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_login_error_description.tr()));
    }
  }

  void changeRememberMe(bool value) {
    emit(LoginChecking());
    rememberMe = value;
    emit(LoginDisplay());
  }

  void changeVisible() {
    emit(LoginChecking());
    isObscure = !isObscure;
    emit(LoginDisplay());
  }

  // Pref Methods
  Future<String> getEmailPref() async {
    SharedPreferences prefs = await preferences;
    return prefs.getString("email") ?? "";
  }

  Future<String> getPasswordPref() async {
    SharedPreferences prefs = await preferences;
    return prefs.getString("password") ?? "";
  }

  Future<bool> getRememberMe() async {
    SharedPreferences prefs = await preferences;
    return prefs.getBool("rememberMe") ?? false;
  }

  void setEmailPref() async {
    SharedPreferences prefs = await preferences;
    prefs.setString("email", emailController.text);
  }

  void setPasswordPref() async {
    SharedPreferences prefs = await preferences;
    prefs.setString("password", passwordController.text);
  }

  void setRememberMe() async {
    SharedPreferences prefs = await preferences;
    prefs.setBool("rememberMe", rememberMe);
  }

  void clearSavedPrefs() async {
    SharedPreferences prefs = await preferences;
    prefs.remove("email");
    prefs.remove("password");
    prefs.remove("rememberMe");
  }

  void checkPrefs() {
    updatePrefRememberMe();
    emit(LoginFirstTime());
  }

  Future<void> updatePrefRememberMe() async {
    await getRememberMe().then((value) => rememberMe = value);
    emit(LoginDisplay());
  }
}
