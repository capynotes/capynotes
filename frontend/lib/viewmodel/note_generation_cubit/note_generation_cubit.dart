import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'note_generation_state.dart';

class NoteGenerationCubit extends Cubit<NoteGenerationState> {
  NoteGenerationCubit() : super(NoteGenerationInitial());
  bool isGenerateFlashcards = true;
  String noteName = "";

  void changeGenerateFlashcards(bool value) {
    emit(NoteGenerationCheck());
    isGenerateFlashcards = value;
    emit(NoteGenerationDisplay());
  }
}
