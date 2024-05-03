package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.Note;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {
    Optional<List<Note>> findNoteByUserId(Long userId);
    Optional<Note> findNoteById(Long noteId);
    @Query(nativeQuery = true, value = "SELECT id, note_id, diagram_code, diagram_key FROM diagram WHERE note_id=:noteId")
    List<Object[]> findDiagramsByNoteId(Long noteId);
}
