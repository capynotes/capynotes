part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterChecking extends RegisterState {}

class RegisterDisplay extends RegisterState {}

class RegisterError extends RegisterState {
  final String title;
  final String description;

  RegisterError(this.title, this.description);
}

class RegisterNoTerms extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String title;
  final String description;

  RegisterSuccess(this.title, this.description);
}
