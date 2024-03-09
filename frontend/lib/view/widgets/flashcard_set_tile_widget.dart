import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../model/flashcard/flashcard_set_model.dart';

class FlashcardSetTile extends StatelessWidget {
  const FlashcardSetTile({
    super.key,
    this.flashcardSet,
  });
  final FlashcardSetModel? flashcardSet;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey)),
        title: Text(flashcardSet?.title ?? "No Title"),
        subtitle: Text("${flashcardSet?.cards?.length.toString()} cards"),
        dense: true,
        trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.router.pushNamed("/edit-flashcard/${flashcardSet?.id}");
            }),
        onTap: () {
          //TODO: Navigate to flashcard set screen
          context.router.navigateNamed("/flashcard/${flashcardSet?.id}");
        },
      ),
    );
  }
}
