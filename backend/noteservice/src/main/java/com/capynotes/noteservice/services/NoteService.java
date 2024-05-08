package com.capynotes.noteservice.services;

import com.capynotes.noteservice.dtos.CrossReference;
import com.capynotes.noteservice.dtos.NoteDto;
import com.capynotes.noteservice.dtos.NoteGrid;
import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.exceptions.FileDownloadException;
import com.capynotes.noteservice.exceptions.FileUploadException;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.models.Tag;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

@Service
public interface NoteService {
    void deleteNote(Long id);
    Note uploadAudio(MultipartFile multipartFile, Long userId, String fileName) throws IOException, FileUploadException;
    Note uploadAudioFromURL(String videoUrl, String fileName, Long userId, Long folderId);
    List<Note> findNotesByUserId(Long userId) throws FileNotFoundException;
    NoteDto findNoteByNoteId(Long noteId) throws FileNotFoundException;
    List<NoteGrid> getNotesInGrid(Long userId) throws FileNotFoundException;
    void addTag(Tag tag) throws FileNotFoundException;
    void deleteTag(Long id) throws FileNotFoundException;
    boolean addNoteToFolder(Note note, Long folderId);
    Note addNote(Note note);
    void createPdf(NoteDto noteDto, String fileName) throws IOException, InterruptedException;
    byte[] downloadFromS3(String key) throws IOException;
    void uploadToS3(File file) throws IOException;
    void updateNote(Long noteId, NoteStatus noteStatus, String pdfKey);
    List<NoteGrid> getNotesWithSameTag(CrossReference crossReference) throws FileNotFoundException;
}
