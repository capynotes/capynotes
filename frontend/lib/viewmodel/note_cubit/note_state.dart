part of 'note_cubit.dart';

sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NotesDisplay extends NoteState {
  List<NoteModel> pendingNotes;
  List<NoteModel> doneNotes;
  List<NoteModel> allNotes;
  NotesDisplay(
      {required this.pendingNotes,
      required this.doneNotes,
      required this.allNotes});
}

final class NoteDisplay extends NoteState {
  NoteModel note;

  NoteDisplay({required this.note});
}

final class NoteNotFound extends NoteState {}

final class NoteError extends NoteState {
  final String title;
  final String description;

  NoteError(this.title, this.description);
}

final class NoteSuccess extends NoteState {
  final String title;
  final String description;

  NoteSuccess(this.title, this.description);
}
