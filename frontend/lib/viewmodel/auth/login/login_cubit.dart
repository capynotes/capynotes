import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/auth/login_model.dart';
import '../../../model/user/user_model.dart';
import '../../../services/auth_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.service) : super(LoginInitial());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginModel loginModel = LoginModel();
  AuthService service;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  bool rememberMe = false;
  bool isObscure = true;

  Future<void> login() async {
    emit(LoginLoading());
    loginModel.email = emailController.text;
    loginModel.password = passwordController.text;
    UserModel? response = await service.login(loginModel);
    if (response != null) {
      if (rememberMe) {
        setEmailPref();
        setPasswordPref();
      } else {
        clearSavedPrefs();
      }
      setRememberMe();
      //TODO: locale keys
      emit(LoginSuccess("Login Successful", "Succesfully Logged In"));
    } else {
      //TODO: locale keys
      emit(
          LoginError("Login Failed", "Your username or password is incorrect"));
    }
  }

  void changeRememberMe() {
    emit(LoginChecking());
    rememberMe = !rememberMe;
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
  }

  void checkPrefs() {
    emit(LoginFirstTime());
  }

  void updatePrefRememberMe() {
    getRememberMe().then((value) => rememberMe = value);
  }
}
