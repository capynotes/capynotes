package com.capynotes.noteservice.services;

import com.capynotes.noteservice.models.Flashcard;
import com.capynotes.noteservice.models.FlashcardSet;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FlashcardService {
    Flashcard addFlashcard(Flashcard flashcard);
    List<Flashcard> findAllFlashcards();
    Flashcard findFlashcardById(Long id);
    void deleteFlashcardById(Long id);
    Flashcard editFlashcard(Flashcard flashcard, Flashcard oldFlashcard);
    FlashcardSet createSet(FlashcardSet flashcardSet);
    FlashcardSet getFlashcardSet(Long id);
    List<FlashcardSet> getFlashcardSetsOfUser(Long id);
    List<FlashcardSet> getFlashcardSetsOfNote(Long id);
    void deleteFlashcardSetById(Long id);
}
