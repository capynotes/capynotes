package com.capynotes.noteservice.services;

import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.exceptions.FileDownloadException;
import com.capynotes.noteservice.exceptions.FileUploadException;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.repositories.NoteRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class NoteServiceImpl implements NoteService {
    private final NoteRepository noteRepository;
    public NoteServiceImpl(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    @Override
    public Note createNote(Note note, String summary) {
        LocalDateTime now = LocalDateTime.now();
        note.setUploadTime(now);
        return noteRepository.save(note);
    }

    @Override
    public void deleteNote(Long id) {
        noteRepository.deleteById(id);
    }

    @Override
    public Note uploadNote(MultipartFile multipartFile, Long userId) throws IOException, FileUploadException {
        return null;
    }

    @Override
    public Object downloadNote(String fileName) throws IOException, FileDownloadException {
        return null;
    }

    @Override
    public Note updateNoteStatus(Long noteId, NoteStatus status) {
        Optional<Note> optionalNote = noteRepository.findById(noteId);
        if (optionalNote.isEmpty()) {
            throw new IllegalArgumentException("Note with id " + noteId + " does not exist.");
        }
        Note note = optionalNote.get();
        note.setStatus(status);
        noteRepository.save(note);
        return note;
    }
}
