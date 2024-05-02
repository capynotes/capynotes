package com.capynotes.noteservice.controllers;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.capynotes.noteservice.dtos.NoteDto;
import com.capynotes.noteservice.dtos.NoteRequest;
import com.capynotes.noteservice.dtos.Response;
import com.capynotes.noteservice.dtos.VideoTranscribeRequest;
import com.capynotes.noteservice.models.Note;
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
    private NoteService noteService;
    private AmazonSQS sqsClient;
    private String queueUrl;
    private String youtubeQueueUrl;

    public NoteController(NoteService noteService) {
        this.noteService = noteService;
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

    @PostConstruct
    public void init() {
        sqsClient = AmazonSQSClientBuilder.standard()
                .withCredentials(
                        new AWSStaticCredentialsProvider(new BasicAWSCredentials("your_access_key", "your_secret_key")))
                .withRegion("your_region")
                .build();
        queueUrl = sqsClient.getQueueUrl("transcription_queue").getQueueUrl();
        youtubeQueueUrl = sqsClient.getQueueUrl("youtube_queue").getQueueUrl();
    }

    @PostMapping("/upload-audio")
    public ResponseEntity<?> uploadAudio(@RequestParam("file") MultipartFile file,
            @RequestParam("fileName") String fileName, @RequestParam("userId") Long userId) {
        Response response;
        try {
            Note note = noteService.uploadAudio(file, userId, fileName);
            String jsonString = "{\"noteId\":" + note.getId().toString() + "\"}";
            sqsClient.sendMessage(queueUrl, jsonString);
            System.out.println(" [x] Sent '" + jsonString + "'");
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
            String jsonString = "{\"noteId\":" + note.getId().toString() + ", \"videoUrl\":\"" + videoUrl
                    + "\", \"noteName\":\"" + fileName + "\"}";
            sqsClient.sendMessage(youtubeQueueUrl, jsonString);
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
}
