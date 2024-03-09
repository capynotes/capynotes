package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.Transcript;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TranscriptRepository extends JpaRepository<Transcript, Long> {
    @Query("SELECT t FROM Transcript t WHERE t.note_id = ?1")
    Optional<Transcript> getTranscriptByNote_id(Long noteId);
}
