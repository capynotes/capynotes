import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../enums/note_status_enum.dart';
import '../../model/flashcard/add_flashcard_set_model.dart';
import '../../model/flashcard/flashcard_set_model.dart';
import '../../model/note_model.dart';
import '../../services/note_service.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit(this.service) : super(NoteInitial());
  final NoteService service;
  final String path = "assets/audio/csgo.mp3";
  NoteModel? selectedNote;
  // AudioPlayer player = AudioPlayer();
  TextEditingController fcSetNameController = TextEditingController();

  Future<void> getMyNotes() async {
    emit(NoteLoading());
    List<Note>? allNotes = await service.getMyNotes();
    print(allNotes);
    if (allNotes == null) {
      emit(NoteError("Error", "Error"));
    } else if (allNotes.isEmpty) {
      emit(NoteNotFound());
    } else {
      List<Note>? pendingNotes = allNotes
          .where((element) =>
              element.status == NoteStatus.TRANSCRIBING ||
              element.status == NoteStatus.SUMMARIZING)
          .toList();
      List<Note>? doneNotes = allNotes
          .where((element) => element.status == NoteStatus.DONE)
          .toList();
      emit(NotesDisplay(
          pendingNotes: pendingNotes,
          doneNotes: doneNotes,
          allNotes: allNotes));
    }
  }

  Future<void> getNote(int id) async {
    emit(NoteLoading());
    selectedNote = await service.getNote(id);
    if (selectedNote == null) {
      emit(NoteNotFound());
    } else {
      emit(NoteDisplay(note: selectedNote!));
    }
  }

  Future<void> createFlashcardSet() async {
    emit(NoteLoading());
    AddFlashcardSetModel fcSetModel = AddFlashcardSetModel(
        userId: 1,
        title: fcSetNameController.text,
        note: NoteID(id: selectedNote!.note!.id));
    FlashcardSetModel? result = await service.createFlashcardSet(fcSetModel);
    if (result == null) {
      emit(NoteError("Creation Failed", "Could not create flashcard set"));
    } else {
      print(result);
      emit(NoteSuccess("Set Created Successfully",
          "Flashcard Set \"${result.title}\" Created Successfully"));
    }
  }
}
