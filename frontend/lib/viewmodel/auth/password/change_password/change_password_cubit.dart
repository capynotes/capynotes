import 'package:capynotes/model/user/user_info_model.dart';
import 'package:capynotes/services/auth_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/auth/change_password_model.dart';
import '../../../../translations/locale_keys.g.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this.service) : super(ChangePasswordInitial());
  AuthService service;
  ChangePasswordModel changePasswordModel =
      ChangePasswordModel(id: UserInfo.loggedUser!.id);

  Future<void> changePassword(String email) async {
    emit(ChangePasswordLoading());

    String? changePasswordResponse =
        await service.changePassword(changePasswordModel);
    if (changePasswordResponse == null) {
      emit(ChangePasswordError(
          LocaleKeys.dialogs_error_dialogs_change_password_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_change_password_error_description
              .tr()));
    } else {
      emit(ChangePasswordSuccess(
          LocaleKeys.dialogs_success_dialogs_change_password_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_change_password_success_description
              .tr()));
    }
  }
}
