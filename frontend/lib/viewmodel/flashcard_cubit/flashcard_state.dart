part of 'flashcard_cubit.dart';

sealed class FlashcardState {}

final class FlashcardInitial extends FlashcardState {}

final class FlashcardDisplay extends FlashcardState {}

final class FlashcardLoading extends FlashcardState {}

final class FlashcardError extends FlashcardState {
  final String title;
  final String description;

  FlashcardError(this.title, this.description);
}

final class FlashcardSetEmpty extends FlashcardState {
  final String title;
  final String description;

  FlashcardSetEmpty(this.title, this.description);
}

final class FlashcardSuccess extends FlashcardState {
  final String title;
  final String description;

  FlashcardSuccess(this.title, this.description);
}
