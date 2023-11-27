import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../translations/locale_keys.g.dart';

part 'note_generation_state.dart';

class NoteGenerationCubit extends Cubit<NoteGenerationState> {
  NoteGenerationCubit() : super(NoteGenerationInitial());
  bool isGenerateFlashcards = true;
  TextEditingController noteNameController = TextEditingController();
  String selectedFileName = LocaleKeys.labels_no_file_selected.tr();
  File? audioFile;

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
      emit(NoteGenerationError(
          LocaleKeys.dialogs_error_dialogs_file_pick_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_file_pick_error_description.tr()));
    }
  }

  Future<void> recordAudio() async {}

  Future<void> generateNote() async {
    emit(NoteGenerationLoading());
    // send generation request
    if (true) {
      emit(NoteGenerationSuccess(
          LocaleKeys.dialogs_success_dialogs_note_generation_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_note_generation_success_description
              .tr()));
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

  void changeGenerateFlashcards(bool value) {
    emit(NoteGenerationCheck());
    isGenerateFlashcards = value;
    emit(NoteGenerationDisplay());
  }
}
