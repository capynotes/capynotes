package com.capynotes.noteservice.controllers;

import com.capynotes.noteservice.dtos.NoteRequest;
import com.capynotes.noteservice.dtos.Response;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.services.NoteService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("api/note")
public class NoteController {
    NoteService noteService;
    public NoteController(NoteService noteService) {
        this.noteService = noteService;
    }
    @PostMapping("/upload-audio")
    public ResponseEntity<?> uploadAudio(@RequestParam("file") MultipartFile file, @RequestParam("fileName") String fileName, @RequestParam("userId") Long userId) {
        Response response;
        try {
            Note note = noteService.uploadAudio(file, userId, fileName);
            response = new Response("Note created.", 200, note);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred." + e.toString(), 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteNote(@PathVariable("id") long id) {
        Response response;
        try {
            noteService.deleteNote(id);
            response = new Response("Note deleted.", 200, null);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred." + e.toString(), 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
