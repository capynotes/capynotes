import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';

part 'note_generation_state.dart';

class NoteGenerationCubit extends Cubit<NoteGenerationState> {
  NoteGenerationCubit() : super(NoteGenerationInitial());
  bool isGenerateFlashcards = true;
  TextEditingController noteNameController = TextEditingController();
  String selectedFileName = "No file selected";
  File? audioFile;

  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      emit(NoteGenerationCheck());
      audioFile = File(result.files.single.path!);
      selectedFileName = result.files.single.name;
      emit(NoteGenerationSuccess("File Picked Successfully!",
          "File $selectedFileName picked successfully."));
    } else {
      emit(NoteGenerationError("File Picking Failed!",
          "You did not select a file. Please try again."));
    }
  }

  Future<void> recordAudio() async {}

  Future<void> generateNote() async {
    emit(NoteGenerationLoading());
    // send generation request
    if (true) {
      emit(NoteGenerationSuccess(
          "Note Generated Successfully!", "Note generated successfully."));
    } else {
      emit(NoteGenerationError("Note Generation Failed!",
          "Could not generate note. Please try again."));
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
