import 'package:capynotes/model/user/user_info_model.dart';
import 'package:capynotes/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/auth/change_password_model.dart';

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
      // TODO: locale keys
      emit(ChangePasswordError("Could not change password",
          "We could not change your password. Please try again later."));
    } else {
      // TODO: locale keys
      emit(ChangePasswordSuccess(
          "Password Changed!", "Your password is successfully changed."));
    }
  }
}
