import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:capynotes/model/cross_reference_model.dart';
import 'package:capynotes/model/tag_model.dart';
import 'package:capynotes/model/user/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../enums/note_status_enum.dart';
import '../../model/flashcard/add_flashcard_set_model.dart';
import '../../model/flashcard/flashcard_set_model.dart';
import '../../model/folder/note_grid_model.dart';
import '../../model/note_model.dart';
import '../../services/note_service.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit(this.service) : super(NoteInitial());
  final NoteService service;
  NoteModel? selectedNote;
  TextEditingController fcSetNameController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  List<NoteGridModel>? crossList;

  Future<void> getMyNotes() async {
    emit(NoteLoading());
    List<Note>? allNotes = await service.getMyNotes();
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
      final audioUrl = await getDownloadUrl(
          key: selectedNote!.note!.audioKey!,
          accessLevel: StorageAccessLevel.guest);
      selectedNote!.audioUrl = audioUrl;
      emit(NoteDisplay());
    }
  }

  Future<String> getDownloadUrl({
    required String key,
    required StorageAccessLevel accessLevel,
  }) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: StorageGetUrlOptions(
          accessLevel: accessLevel,
          pluginOptions: const S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;
      return result.url.toString();
    } on StorageException catch (e) {
      safePrint('Could not get a downloadable URL: ${e.message}');
      rethrow;
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
      emit(NoteSuccess("Note Created Successfully",
          "Flashcard Set \"${result.title}\" Created Successfully"));
    }
  }

  Future<void> addTagToNote() async {
    emit(NoteLoading());
    AddTagModel tagModel = AddTagModel(
        note: TagNote(id: selectedNote!.note!.id), name: tagController.text);
    TagResponseModel? result = await service.addTag(tagModel);
    if (result == null) {
      emit(NoteError("Add Failed", "Could not add tag to note"));
    } else {
      emit(NoteSuccess("Tag Added Successfully",
          "Tag \"${result.name}\" Added Successfully"));
    }
  }

  Future<void> getCrossReferenced(String tag) async {
    emit(NoteCrossCheck());
    CrossReferenceModel crossReferenceModel = CrossReferenceModel(
        userId: UserInfo.loggedUser!.id!,
        currentNoteId: selectedNote!.note!.id!,
        tag: tag);
    List<NoteGridModel>? crossedNotes =
        await service.getCrossReferenced(crossReferenceModel);

    if (crossedNotes == null || crossedNotes.isEmpty) {
      crossList = [];
      print(crossedNotes);
    } else {
      crossList = crossedNotes;
    }
    emit(NoteCrossDisplay());
  }

  emitDisplay() {
    emit(NoteDisplay());
  }
}
