package com.capynotes.noteservice.services;

import com.capynotes.noteservice.dtos.NoteDto;
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
    void deleteNote(Long id);
    Note uploadAudio(MultipartFile multipartFile, Long userId, String fileName) throws IOException, FileUploadException;
    Note uploadAudioFromURL(String videoUrl, String fileName, Long userId);
    List<Note> findNotesByUserId(Long userId) throws FileNotFoundException;
    NoteDto findNoteByNoteId(Long noteId) throws FileNotFoundException;

}
