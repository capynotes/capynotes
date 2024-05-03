part of 'note_cubit.dart';

sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NotesDisplay extends NoteState {
  List<Note> pendingNotes;
  List<Note> doneNotes;
  List<Note> allNotes;
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

final class NoteCrossList extends NoteState {
  List<NoteGridModel> crossList;
  NoteCrossList({required this.crossList});
}
