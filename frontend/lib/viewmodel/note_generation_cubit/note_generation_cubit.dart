import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'note_generation_state.dart';

class NoteGenerationCubit extends Cubit<NoteGenerationState> {
  NoteGenerationCubit() : super(NoteGenerationInitial());
  bool isGenerateFlashcards = true;
  TextEditingController noteNameController = TextEditingController();
  String selectedFileName = "No file selected";

  void changeGenerateFlashcards(bool value) {
    emit(NoteGenerationCheck());
    isGenerateFlashcards = value;
    emit(NoteGenerationDisplay());
  }
}
