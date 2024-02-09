package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.FlashcardSet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlashcardSetRepository extends JpaRepository<FlashcardSet, Long> {
    @Query("SELECT fcs FROM FlashcardSet fcs WHERE fcs.userId=?1")
    List<FlashcardSet> findFlashcardSetByUserId(Long id);

    @Query("SELECT fcs FROM FlashcardSet fcs WHERE fcs.note.id=?1")
    List<FlashcardSet> findFlashcardSetByNoteId(Long id);
}
