import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/note_model.dart';
import '../../services/note_service.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit(this.service) : super(NoteInitial());
  final NoteService service;

  Future<void> getMyNotes() async {
    emit(NoteLoading());
    List<NoteModel>? allNotes = await service.getMyNotes();
    if (allNotes == null) {
      emit(NoteError("Error", "Error"));
    } else if (allNotes.isEmpty) {
      emit(NoteNotFound());
    } else {
      List<NoteModel>? pendingNotes = allNotes;
      // .where((element) => element.status == NoteStatus.PENDING)
      // .toList();
      List<NoteModel>? doneNotes = allNotes;
      // .where((element) => element.status == NoteStatus.DONE)
      // .toList();
      emit(NotesDisplay(
          pendingNotes: pendingNotes,
          doneNotes: doneNotes,
          allNotes: allNotes));
    }
  }

  Future<void> getNote(int id) async {
    emit(NoteLoading());
    NoteModel? note = await service.getNote(id);
    if (note == null) {
      emit(NoteNotFound());
    } else {
      emit(NoteDisplay(note: note));
    }
  }
}
