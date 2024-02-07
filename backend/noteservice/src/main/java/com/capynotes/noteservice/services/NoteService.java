package com.capynotes.noteservice.services;

import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.exceptions.FileDownloadException;
import com.capynotes.noteservice.exceptions.FileUploadException;
import com.capynotes.noteservice.models.Note;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

@Service
public interface NoteService {
    Note createNote(Note note, String summary);
    void deleteNote(Long id);
    Note uploadNote(MultipartFile multipartFile, Long userId) throws IOException, FileUploadException;
    Object downloadNote(String fileName) throws IOException, FileDownloadException;
    Note updateNoteStatus(Long noteId, NoteStatus status);
}
