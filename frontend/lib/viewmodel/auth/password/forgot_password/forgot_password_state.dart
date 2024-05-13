part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordDisplay extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String title;
  final String description;

  ForgotPasswordError(this.title, this.description);
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String title;
  final String description;

  ForgotPasswordSuccess(this.title, this.description);
}
