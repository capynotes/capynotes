part of 'note_generation_cubit.dart';

@immutable
sealed class NoteGenerationState {}

final class NoteGenerationInitial extends NoteGenerationState {}

final class NoteGenerationCheck extends NoteGenerationState {}

final class NoteGenerationDisplay extends NoteGenerationState {}
