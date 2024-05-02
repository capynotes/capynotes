import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:capynotes/model/auth/register_model.dart';
import 'package:capynotes/model/user/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/auth_service.dart';
import '../../../translations/locale_keys.g.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.service) : super(RegisterInitial());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController verifyPasswordController =
      TextEditingController();
  final TextEditingController confirmationCodeController =
      TextEditingController();
  AuthService service;
  RegisterModel registerModel = RegisterModel();
  bool isObscure = true;
  bool agreeTerms = false;

  /// Signs a user up with a username, password, and email. The required
  /// attributes may be different depending on your app's configuration.
  Future<void> amplifyRegister({
    required String email,
    required String password,
  }) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
      };
      final result = await Amplify.Auth.signUp(
        username: emailController.text,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      await _amplifyHandleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error signing up user: ${e.message}');
      emit(RegisterError(
          LocaleKeys.dialogs_error_dialogs_register_error_title.tr(),
          e.message));
    }
  }

  Future<void> _amplifyHandleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _amplifyHandleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        safePrint('Sign up is complete');
        emit(RegisterSuccess(
            LocaleKeys.dialogs_success_dialogs_register_success_title.tr(),
            LocaleKeys.dialogs_success_dialogs_register_success_description
                .tr()));
        break;
    }
  }

  void _amplifyHandleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    emit(RegisterConfirm(codeDeliveryDetails));
  }

  Future<void> amplifyConfirmUser({
    required String username,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );
      // Check if further confirmations are needed or if
      // the sign up is complete.
      await _amplifyHandleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
    }
  }

  Future<void> register() async {
    emit(RegisterLoading());
    registerModel.name = nameController.text;
    registerModel.surname = surnameController.text;
    registerModel.email = emailController.text;
    registerModel.password = passwordController.text;
    registerModel.role = "ROLE_USER";

    UserModel? registerResponse = await service.register(registerModel);

    if (registerResponse == null) {
      emit(RegisterError(
          LocaleKeys.dialogs_error_dialogs_register_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_register_error_description.tr()));
    } else {
      amplifyRegister(
          email: emailController.text, password: passwordController.text);
      // emit(RegisterSuccess(
      //     LocaleKeys.dialogs_success_dialogs_register_success_title.tr(),
      //     LocaleKeys.dialogs_success_dialogs_register_success_description
      //         .tr()));
    }
  }

  void changeVisible() {
    emit(RegisterChecking());
    isObscure = !isObscure;
    emit(RegisterDisplay());
  }

  void changeTerms() {
    emit(RegisterChecking());
    agreeTerms = !agreeTerms;
    emit(RegisterDisplay());
  }

  void emitNoTerms() {
    emit(RegisterNoTerms());
  }
}
