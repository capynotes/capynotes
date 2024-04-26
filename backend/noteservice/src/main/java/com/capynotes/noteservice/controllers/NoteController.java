package com.capynotes.noteservice.controllers;

import com.capynotes.noteservice.dtos.*;
import com.capynotes.noteservice.models.FolderItem;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.models.Tag;
import com.capynotes.noteservice.services.FolderItemService;
import com.capynotes.noteservice.services.NoteService;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.TimeoutException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

import jakarta.annotation.PostConstruct;

@RestController
@RequestMapping("api/note")
public class NoteController {
    NoteService noteService;
    FolderItemService folderItemService;
    ConnectionFactory factory;
    Connection connection;
    Channel channel;

    String QUEUE_NAME = "transcription_queue";
    String YOUTUBE_QUEUE_NAME = "youtube_queue";

    public NoteController(NoteService noteService, FolderItemService folderItemService) {
        this.noteService = noteService;
        this.folderItemService = folderItemService;
    }

    @PostConstruct
    public void init() {
        factory = new ConnectionFactory();
        factory.setHost("rabbitmq");
        factory.setPort(5672);
        factory.setUsername("guest");
        factory.setPassword("guest");
        try {
            connection = factory.newConnection();
            channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME, false, false, false, null);
            channel.queueDeclare(YOUTUBE_QUEUE_NAME, false, false, false, null);
            System.out.println(" [*] Waiting for messages.");
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (TimeoutException e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping("/upload-audio")
    public ResponseEntity<?> uploadAudio(@RequestParam("file") MultipartFile file,
            @RequestParam("fileName") String fileName, @RequestParam("userId") Long userId) {
        Response response;
        try {
            Note note = noteService.uploadAudio(file, userId, fileName);
            channel.basicPublish("", QUEUE_NAME, null, note.getId().toString().getBytes(StandardCharsets.UTF_8));
            System.out.println(" [x] Sent '" + note.getId().toString() + "'");
            response = new Response("Note created.", 200, note);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred." + e.toString(), 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/from-video")
    public ResponseEntity<?> uploadFromVideo(@RequestBody VideoTranscribeRequest videoTranscribeRequest) {
        Response response;
        String videoUrl = videoTranscribeRequest.getVideoUrl();
        String fileName = videoTranscribeRequest.getNoteName();
        Long userId = videoTranscribeRequest.getUserId();
        try {
            Note note = noteService.uploadAudioFromURL(videoUrl, fileName, userId);
            String jsonString = "{\"noteId\":" + note.getId().toString() + ", \"videoUrl\":\"" + videoUrl + "\", \"noteName\":\"" + fileName + "\"}";
            channel.basicPublish("", YOUTUBE_QUEUE_NAME, null, jsonString.getBytes(StandardCharsets.UTF_8));
            System.out.println(" [x] Sent note with id '" + note.getId().toString() + "'");
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

    @GetMapping("/user/{id}")
    public Response getUserNotes(@PathVariable("id") Long id) throws FileNotFoundException {
        List<Note> notes;
        try {
            notes = noteService.findNotesByUserId(id);
            return new Response("Notes retrieved successfully.", 200, notes);
        } catch (Exception e) {
            return new Response("An error occurred." + e.toString(), 500, null);
        }
    }

    @GetMapping("/{id}")
    public Response getNote(@PathVariable("id") Long id) throws FileNotFoundException {
        NoteDto note;
        try {
            note = noteService.findNoteByNoteId(id);
            return new Response("Note retrieved successfully.", 200, note);
        } catch (Exception e) {
            return new Response("An error occurred." + e.toString(), 500, null);
        }
    }

    @GetMapping("/user/grid/{id}")
    public Response getUserNotesInGrid(@PathVariable("id") Long id) throws FileNotFoundException {
        List<NoteGrid> notes;
        try {
            notes = noteService.getNotesInGrid(id);
            return new Response("Notes retrieved successfully.", 200, notes);
        } catch (Exception e) {
            return new Response("An error occurred." + e.toString(), 500, null);
        }
    }

    @PostMapping("/add-tag")
    public Response addTagToNote(@RequestBody Tag tag) {
        try {
            noteService.addTag(tag);
            return new Response("Tag added successfully.", 200, tag);
        } catch (Exception e) {
            return new Response("An error occurred." + e.toString(), 500, null);
        }
    }

    @DeleteMapping("/delete-tag/{id}")
    public Response deleteTagFromNote(@PathVariable("id") Long id) {
        try {
            noteService.deleteTag(id);
            return new Response("Tag deleted.", 200, null);
        } catch (Exception e) {
            return new Response("An error occurred." + e.toString(), 500, null);
        }
    }

    @PostMapping("/folder-item/add")
    public Response addFolderItem(@RequestBody FolderItem folderItem) {
        try {
            FolderItem createdItem = folderItemService.addFolderItem(folderItem);
            return new Response("Success", 200, createdItem);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @GetMapping("/folder-item/all/{id}")
    public Response getAllFolderItemsOfUser(@PathVariable("id") long id) {
        try {
            List<Object> items = folderItemService.getFolderItemsOfUser(id);
            return new Response("Success", 200, items);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @GetMapping("/folder-item/{id}")
    public Response getFolderItemById(@PathVariable("id") long id) {
        try {
            FolderItem foundItem = folderItemService.getFolderItem(id);
            return new Response("Success", 200, foundItem);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @DeleteMapping("/folder-item/{id}")
    public Response deleteFolderItemById(@PathVariable("id") long id) {
        try {
            folderItemService.deleteFolderItem(id);
            return new Response("Success", 200, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @PostMapping("/add/{id}")
    public Response addNote(@RequestBody Note note, @PathVariable("id") long folderId) {
        try {
            if(noteService.addNote(note, folderId)) {
                return new Response("Success", 200, note);
            }
            return new Response("Could not add note to folder", 200, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }
}
