import 'dart:io';

import 'package:capynotes/model/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:capynotes/services/note_generation_service.dart';

import '../../model/audio_model.dart';
import '../../model/video_model.dart';
import '../../translations/locale_keys.g.dart';

part 'note_generation_state.dart';

class NoteGenerationCubit extends Cubit<NoteGenerationState> {
  NoteGenerationCubit(this.service) : super(NoteGenerationInitial());
  NoteGenerationService service;

  // bool isGenerateFlashcards = true;
  TextEditingController noteNameController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();
  String selectedFileName = LocaleKeys.labels_no_file_selected.tr();
  File? audioFile;
  Note? generatedNote;

  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      emit(NoteGenerationCheck());
      audioFile = File(result.files.single.path!);
      selectedFileName = result.files.single.name;
      emit(NoteGenerationSuccess(
          LocaleKeys.dialogs_success_dialogs_file_pick_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_file_pick_success_description
              .tr(args: [selectedFileName])));
    } else {
      selectedFileName = LocaleKeys.labels_no_file_selected.tr();
      audioFile = null;
      emit(NoteGenerationError(
          LocaleKeys.dialogs_error_dialogs_file_pick_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_file_pick_error_description.tr()));
    }
  }

  Future<void> recordAudio() async {}

  Future<void> generateNoteFromFile() async {
    emit(NoteGenerationLoading());
    // send generation request
    var response =
        await service.generateNoteFromFile(audioFile!, selectedFileName);

    if (response != null) {
      generatedNote = response;
      emit(NoteGenerationSuccess(
          LocaleKeys.dialogs_success_dialogs_note_generation_success_title.tr(),
          generatedNote!.title ?? ""));
    } else {
      emit(NoteGenerationError(
          LocaleKeys.dialogs_error_dialogs_note_generation_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_note_generation_error_description
              .tr()));
    }
  }

  Future<void> generateNoteFromURL() async {
    emit(NoteGenerationLoading());
    // send generation request
    // TODO: Change userId to dynamic
    VideoModel videoModel = VideoModel(
        url: videoUrlController.text,
        noteName: noteNameController.text,
        userId: 1);
    var response = await service.generateNoteFromURL(videoModel);

    if (response != null) {
      generatedNote = response;
      emit(NoteGenerationSuccess(
          LocaleKeys.dialogs_success_dialogs_note_generation_success_title.tr(),
          generatedNote!.title ?? ""));
    } else {
      emit(NoteGenerationError(
          LocaleKeys.dialogs_error_dialogs_note_generation_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_note_generation_error_description
              .tr()));
    }
  }

  void emitDisplay() {
    emit(NoteGenerationDisplay());
  }

  // void changeGenerateFlashcards(bool value) {
  //   emit(NoteGenerationCheck());
  //   isGenerateFlashcards = value;
  //   emit(NoteGenerationDisplay());
  // }

  void clearSelectedFile() {
    emit(NoteGenerationCheck());
    selectedFileName = LocaleKeys.labels_no_file_selected.tr();
    audioFile = null;
    emit(NoteGenerationDisplay());
  }
}
