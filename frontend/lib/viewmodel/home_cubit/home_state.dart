part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeDisplay extends HomeState {
  List<dynamic> allHomeContents;

  HomeDisplay({required this.allHomeContents});
}

final class HomeNotFound extends HomeState {}

final class HomeError extends HomeState {
  final String title;
  final String description;

  HomeError(this.title, this.description);
}

final class HomeSuccess extends HomeState {
  final String title;
  final String description;

  HomeSuccess(this.title, this.description);
}
