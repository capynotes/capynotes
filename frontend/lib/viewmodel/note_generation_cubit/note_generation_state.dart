part of 'note_generation_cubit.dart';

@immutable
sealed class NoteGenerationState {}

final class NoteGenerationInitial extends NoteGenerationState {}

final class NoteGenerationCheck extends NoteGenerationState {}

final class NoteGenerationDisplay extends NoteGenerationState {}

final class NoteGenerationLoading extends NoteGenerationState {}

class NoteGenerationError extends NoteGenerationState {
  final String title;
  final String description;

  NoteGenerationError(this.title, this.description);
}

class NoteGenerationSuccess extends NoteGenerationState {
  final String title;
  final String description;

  NoteGenerationSuccess(this.title, this.description);
}
