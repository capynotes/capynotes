import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/auth_service.dart';
import '../../../../translations/locale_keys.g.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.service) : super(ForgotPasswordInitial());
  AuthService service;

  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());

    String? forgotPwResponse = await service.forgotPassword(email);
    if (forgotPwResponse == null) {
      emit(ForgotPasswordError(
          LocaleKeys.dialogs_error_dialogs_forgot_password_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_forgot_password_error_description
              .tr()));
    } else {
      emit(ForgotPasswordSuccess(
          LocaleKeys.dialogs_success_dialogs_forgot_password_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_forgot_password_success_description
              .tr()));
    }
  }
}
