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
  AuthService service;
  RegisterModel registerModel = RegisterModel();
  bool isObscure = true;
  bool agreeTerms = false;

  Future<void> register() async {
    emit(RegisterLoading());
    registerModel.name = nameController.text;
    registerModel.surname = surnameController.text;
    registerModel.email = emailController.text;
    registerModel.password = passwordController.text;

    UserModel? registerResponse = await service.register(registerModel);
    if (registerResponse == null) {
      emit(RegisterError(
          LocaleKeys.dialogs_error_dialogs_register_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_register_error_description.tr()));
    } else {
      emit(RegisterSuccess(
          LocaleKeys.dialogs_success_dialogs_register_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_register_success_description
              .tr()));
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
