package com.capynotes.audioservice.controllers;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.TimeoutException;

import jakarta.annotation.PostConstruct;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.capynotes.audioservice.dtos.AudioDto;
import com.capynotes.audioservice.dtos.Response;
import com.capynotes.audioservice.dtos.SummaryRequest;
import com.capynotes.audioservice.dtos.SummaryResponse;
import com.capynotes.audioservice.dtos.TranscribeRequest;
import com.capynotes.audioservice.dtos.TranscribeResponse;
import com.capynotes.audioservice.dtos.VideoTranscribeRequest;
import com.capynotes.audioservice.enums.AudioStatus;
import com.capynotes.audioservice.exceptions.FileEmptyException;
import com.capynotes.audioservice.models.Audio;
import com.capynotes.audioservice.services.AudioService;
import org.springframework.web.multipart.MultipartFile;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

@RestController
@RequestMapping("api/audio")
public class AudioController {
    AudioService audioService;
    ConnectionFactory factory;
    Connection connection;
    Channel channel;

    String QUEUE_NAME = "transcription_queue";

    public AudioController(AudioService audioService) {
        this.audioService = audioService;
    }

   @PostConstruct
   public void init() {
       factory = new ConnectionFactory();
       factory.setHost("localhost");
       try {
            connection = factory.newConnection();
            channel = connection.createChannel();
            channel.queueDeclare(QUEUE_NAME, false, false, false, null);
       } catch (IOException e) {
           throw new RuntimeException(e);
       } catch (TimeoutException e) {
           throw new RuntimeException(e);
       }
   }
    // @CrossOrigin(origins = "*")
    @PostMapping("/upload-foo")
    public void foo(@RequestParam("id") String id) throws IOException {
        channel.basicPublish("", QUEUE_NAME, null, id.getBytes(StandardCharsets.UTF_8));
        System.out.println(" [x] Sent '" + id + "'");
    }

    // @CrossOrigin(origins = "*")
    @PostMapping("/upload")
    public ResponseEntity<?> upload(@RequestParam("file") MultipartFile file, @RequestParam("fileName") String fileName)
            throws FileEmptyException {
        Response response;
        if (file.isEmpty()) {
            throw new FileEmptyException("File is empty. Cannot save an empty file");
        }
        Long userId = 1L;
        try {
            Audio newAudio = audioService.uploadAudioFromFile(file, userId);
            newAudio = audioService.updateAudioStatus(newAudio.getId(), AudioStatus.PENDING);
            // TODO: Maybe move this to service etc.
            // Send request to S2T service

            channel.basicPublish("", QUEUE_NAME, null, newAudio.getId().toString().getBytes(StandardCharsets.UTF_8));
            System.out.println(" [x] Sent '" + newAudio.getId().toString() + "'");

            return (ResponseEntity<?>) ResponseEntity.ok();
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
        Long userId = 1L;
        try {
            Audio newAudio = audioService.uploadAudioFromURL(videoUrl, fileName, userId);
            // response = new Response("Video transcribed successfully" , 200, newAudio);
            // return new ResponseEntity<>(response, HttpStatus.OK);
            //TODO: these wont be handled here
            // Send request to summary service, get response, update summary, return response
            String summaryUrl = "http://localhost:5001/summarize";
            
            try {
                SummaryRequest summaryRequest = new SummaryRequest(newAudio.getTranscription());
                 HttpEntity<?> summaryRequestEntity = new HttpEntity<>(summaryRequest);
                RestTemplate summaryRestTemplate = new RestTemplate();
                ResponseEntity<SummaryResponse> summaryResponse = summaryRestTemplate.exchange(summaryUrl, HttpMethod.POST,
                        summaryRequestEntity,
                        SummaryResponse.class);
                if (summaryResponse.getStatusCode() == HttpStatus.OK) {
                    SummaryResponse body = summaryResponse.getBody();
                    newAudio = audioService.updateAudioSummary(newAudio.getId(), body.getSummary());
                    AudioDto audioDto = new AudioDto(newAudio);
                    response = new Response("Upload successful.", 200, audioDto);
                    return new ResponseEntity<>(response, HttpStatus.OK);
                } else {
                    response = new Response("An error occurred.", 500, null);
                    return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
                }
            } catch (Exception e) {
                // TODO: handle exception
                response = new Response("An error occurred during summarization." + e.toString(), 500, null);
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred." + e.toString(), 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        
    }

    @GetMapping("/{id}")
    public Response getAudio(@PathVariable("id") Long id) throws FileNotFoundException {
        List<Audio> audios;
        try {
            audios = audioService.findAudioByUserId(id);
            return new Response("Audios retrieved successfully.", 200, audios);
        } catch (Exception e) {
            return new Response("An error occurred." + e.toString(), 500, null);
        }
    }
}
