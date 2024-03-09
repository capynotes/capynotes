package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.Timestamp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TimestampRepository extends JpaRepository<Timestamp, Long> {
    @Query("SELECT ts FROM Timestamp ts WHERE ts.transcript.id = ?1")
    Optional<List<Timestamp>> getTimestampsByTranscriptId(Long transcriptId);
}
