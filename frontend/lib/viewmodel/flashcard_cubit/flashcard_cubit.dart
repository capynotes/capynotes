import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

import '../../model/flashcard_model.dart';
import '../../view/widgets/flashcard_widgets.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  FlashcardCubit() : super(FlashcardInitial());
  int currentIndex = 0;
  static final List<Flashcard> flashcards = [
    Flashcard(
        setID: 0,
        cardID: 0,
        front: "FCFS",
        back:
            "First Come First Serve scheduling algorithm where processes are scheduled in the order they arrive in the queue."),
    Flashcard(
        setID: 0,
        cardID: 1,
        front: "SJF",
        back:
            "Shortest Job First scheduling algorithm that selects the process with the shortest next CPU burst time. "),
    Flashcard(
        setID: 0,
        cardID: 2,
        front: "Time Quantum",
        back:
            "Maximum time a process can run before being preempted in Round Robin scheduling."),
    Flashcard(
        setID: 0,
        cardID: 3,
        front: "Response Time",
        back:
            "Time from when a process enters ready queue to when it starts receiving CPU service."),
    Flashcard(
        setID: 0,
        cardID: 4,
        front: "Turnaround Time",
        back: "Total time spent in the system from submission to completion."),
    Flashcard(
        setID: 0,
        cardID: 5,
        front: "SRJF",
        back:
            "Shortest Remaining Job First scheduling algorithm which is the preemptive version of SJF that gives priority to processes with the shortest remaining time over those with longer times."),
  ];
  final List<FlipCard> allFlashcardList = List.generate(
    flashcards.length,
    (index) => FlipCard(
      frontWidget: FlashcardFace(text: flashcards[index].front),
      backWidget: FlashcardFace(text: flashcards[index].back),
      controller: flashcards[index].controller,
      rotateSide: RotateSide.left,
      onTapFlipping: true,
    ),
  );
}
