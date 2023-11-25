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

  AuthService service;
  late final String name;
  late final String surname;
  late final String email;
  late final String password;
  late final String role;
  late final RegisterModel registerModel;
  bool isObscure = true;

  Future<void> register() async {
    emit(RegisterLoading());
    registerModel = RegisterModel(
        name: name,
        surname: surname,
        email: email,
        password: password,
        role: role);
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
}
