package com.capynotes.noteservice.services;

import com.capynotes.noteservice.models.Flashcard;
import com.capynotes.noteservice.models.FlashcardSet;
import com.capynotes.noteservice.repositories.FlashcardRepository;
import com.capynotes.noteservice.repositories.FlashcardSetRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class FlashcardServiceImpl implements FlashcardService {
    private final FlashcardRepository flashcardRepository;
    private final FlashcardSetRepository flashcardSetRepository;
    public FlashcardServiceImpl(FlashcardRepository flashcardRepository, FlashcardSetRepository flashcardSetRepository) {
        this.flashcardRepository = flashcardRepository;
        this.flashcardSetRepository = flashcardSetRepository;
    }
    @Override
    public Flashcard addFlashcard(Flashcard flashcard) {
        return flashcardRepository.save(flashcard);
    }

    @Override
    public List<Flashcard> findAllFlashcards() {
        return flashcardRepository.findAll();
    }

    @Override
    public Flashcard findFlashcardById(Long id) {
        Optional<Flashcard> flashcard = flashcardRepository.findById(id);
        if(flashcard.isPresent()) {
            return flashcard.get();
        } else {
            throw new RuntimeException("Flashcard with id " + id + " does not exist.");
        }
    }

    @Override
    public void deleteFlashcardById(Long id) {
        Optional<Flashcard> flashcard = flashcardRepository.findById(id);
        if(flashcard.isPresent()) {
            flashcardRepository.deleteById(id);
        } else {
            throw new RuntimeException("Flashcard with id " + id + " does not exist.");
        }
    }

    @Override
    public Flashcard editFlashcard(Flashcard flashcard, Flashcard oldFlashcard) {
        oldFlashcard.edit(flashcard);
        return flashcardRepository.save(oldFlashcard);
    }

    @Override
    public FlashcardSet createSet(FlashcardSet flashcardSet) {
        LocalDateTime now = LocalDateTime.now();
        flashcardSet.setCreationTime(now);
        return flashcardSetRepository.save(flashcardSet);
    }

    @Override
    public FlashcardSet getFlashcardSet(Long id) {
        Optional<FlashcardSet> flashcardSet = flashcardSetRepository.findById(id);
        if(flashcardSet.isPresent()) {
            return flashcardSet.get();
        } else {
            throw new RuntimeException("Flashcard Set with id " + id + " does not exist.");
        }
    }

    @Override
    public List<FlashcardSet> getFlashcardSetsOfUser(Long id) {
        return flashcardSetRepository.findFlashcardSetByUserId(id);
    }

    @Override
    public List<FlashcardSet> getFlashcardSetsOfNote(Long id) {
        return flashcardSetRepository.findFlashcardSetByNoteId(id);
    }

    @Override
    public void deleteFlashcardSetById(Long id) {
        Optional<FlashcardSet> flashcardSet = flashcardSetRepository.findById(id);
        if(flashcardSet.isPresent()) {
            flashcardSetRepository.deleteById(id);
        } else {
            throw new RuntimeException("FlashcardSet with id " + id + " does not exist.");
        }
    }
}
