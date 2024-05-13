package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.Summary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SummaryRepository extends JpaRepository<Summary, Long> {
    @Query("SELECT s FROM Summary s WHERE s.note_id = ?1")
    Optional<Summary> getSummaryByNote_id(Long noteId);
}
