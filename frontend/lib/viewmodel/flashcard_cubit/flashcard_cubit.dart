import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

import '../../model/flashcard/add_flashcard_model.dart';
import '../../model/flashcard/flashcard_model.dart';
import '../../model/flashcard/flashcard_set_model.dart';
import '../../services/flashcard_service.dart';
import '../../view/widgets/flashcard_widgets.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  FlashcardCubit(this.service) : super(FlashcardInitial());
  final FlashcardService service;
  TextEditingController frontController = TextEditingController();
  TextEditingController backController = TextEditingController();
  TextEditingController editFrontController = TextEditingController();
  TextEditingController editBackController = TextEditingController();
  FlashcardSetModel? flashcards;
  List<FlipCard> allFlashcardList = [];

  Future<void> addFlashcard({required int id}) async {
    emit(FlashcardLoading());
    AddFlashcardModel flashcard = AddFlashcardModel(
      set: SetID(id: id),
      front: frontController.text,
      back: backController.text,
    );
    FlashcardModel? result = await service.addFlashcard(flashcard);
    if (result == null) {
      emit(FlashcardError(
          "Add Failed", "Could not add flashcard. Please try again."));
      return;
    }
    emit(FlashcardSuccess(
        "Added Successfully", "Flashcard added successfully."));
  }

  Future<void> deleteFlashcard({required int id}) async {
    emit(FlashcardLoading());
    bool result = await service.deleteFlashcard(id);
    if (!result) {
      emit(FlashcardError(
          "Delete Failed", "Could not delete flashcard. Please try again."));
      return;
    }
    emit(FlashcardSuccess(
        "Deleted Successfully", "Flashcard deleted successfully."));
  }

  Future<void> editFlashcard({required int id}) async {
    emit(FlashcardLoading());
    FlashcardModel flashcard = FlashcardModel(
      id: id,
      front: editFrontController.text,
      back: editBackController.text,
    );
    FlashcardModel? result = await service.editFlashcard(flashcard);
    if (result == null) {
      emit(FlashcardError(
          "Edit Failed", "Could not edit flashcard. Please try again."));
      return;
    }
    emit(FlashcardSuccess(
        "Edited Successfully", "Flashcard edited successfully."));
  }

  Future<void> getFlashcardSet({required int id}) async {
    emit(FlashcardLoading());
    FlashcardSetModel? result = await service.getFlashcardSet(id);
    if (result == null || result.cards == null) {
      emit(FlashcardError(
          "Get Failed", "Could not get flashcard set. Please try again."));
    } else {
      flashcards = result;
      allFlashcardList = List.generate(
        flashcards!.cards!.length,
        (index) => FlipCard(
          frontWidget:
              FlashcardFace(text: flashcards!.cards![index].front ?? ""),
          backWidget: FlashcardFace(text: flashcards!.cards![index].back ?? ""),
          controller: flashcards!.cards![index].controller,
          rotateSide: RotateSide.left,
          onTapFlipping: true,
        ),
      );
      emit(FlashcardDisplay());
    }
  }

  int currentIndex = 0;
  // static final List<FlashcardModel> flashcards = [
  //   FlashcardModel(
  //       id: 0,
  //       front: "FCFS",
  //       back:
  //           "First Come First Serve scheduling algorithm where processes are scheduled in the order they arrive in the queue."),
  //   FlashcardModel(
  //       id: 1,
  //       front: "SJF",
  //       back:
  //           "Shortest Job First scheduling algorithm that selects the process with the shortest next CPU burst time. "),
  //   FlashcardModel(
  //       id: 2,
  //       front: "Time Quantum",
  //       back:
  //           "Maximum time a process can run before being preempted in Round Robin scheduling."),
  //   FlashcardModel(
  //       id: 3,
  //       front: "Response Time",
  //       back:
  //           "Time from when a process enters ready queue to when it starts receiving CPU service."),
  //   FlashcardModel(
  //       id: 4,
  //       front: "Turnaround Time",
  //       back: "Total time spent in the system from submission to completion."),
  //   FlashcardModel(
  //       id: 5,
  //       front: "SRJF",
  //       back:
  //           "Shortest Remaining Job First scheduling algorithm which is the preemptive version of SJF that gives priority to processes with the shortest remaining time over those with longer times."),
  // ];
}
