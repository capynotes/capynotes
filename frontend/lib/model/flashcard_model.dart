import 'package:flutter_flip_card/flutter_flip_card.dart';

class Flashcard {
  final int setID;
  final int cardID;
  final String front;
  final String back;
  final FlipCardController controller = FlipCardController();

  Flashcard(
      {required this.setID,
      required this.cardID,
      required this.front,
      required this.back});
}
