part of 'change_password_cubit.dart';

sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordDisplay extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String title;
  final String description;

  ChangePasswordError(this.title, this.description);
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String title;
  final String description;

  ChangePasswordSuccess(this.title, this.description);
}
