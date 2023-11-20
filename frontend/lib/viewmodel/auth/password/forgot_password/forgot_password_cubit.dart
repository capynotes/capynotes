import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/auth_service.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.service) : super(ForgotPasswordInitial());
  AuthService service;

  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());

    String? registerResponse = await service.forgotPassword(email);
    if (registerResponse == null) {
      // TODO: locale keys
      emit(ForgotPasswordError("Could not send email",
          "We could not send email to your email address. Please try again later."));
    } else {
      // TODO: locale keys
      emit(ForgotPasswordSuccess("Email Sent!",
          "Password reset instructions are sent to your email."));
    }
  }
}
