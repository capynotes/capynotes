package com.capynotes.audioservice.controllers;

import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.capynotes.audioservice.dtos.Response;
import com.capynotes.audioservice.dtos.TranscribeRequest;
import com.capynotes.audioservice.dtos.TranscribeResponse;
import com.capynotes.audioservice.exceptions.FileEmptyException;
import com.capynotes.audioservice.services.AudioService;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("api/audio")
public class AudioController {
    AudioService audioService;

    public AudioController(AudioService audioService) {
        this.audioService = audioService;
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
            String name = audioService.uploadAudio(file, userId).getName();
            // TODO: Maybe move this to service etc.
            // Send request to S2T service
            String url = "http://localhost:5000/transcribe";
            TranscribeRequest transcribeRequest = new TranscribeRequest(name);
            System.out.println(fileName);
            // System.out.println(name);
            HttpEntity<?> requestEntity = new HttpEntity<>(transcribeRequest);
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<TranscribeResponse> transcribeResponse = restTemplate.exchange(url, HttpMethod.POST, requestEntity,
                    TranscribeResponse.class);

            if (transcribeResponse.getStatusCode() == HttpStatus.OK) {
                TranscribeResponse body = transcribeResponse.getBody();
                response = new Response("Upload successful.", 200, body.getTranscription());
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response = new Response("An error occurred.", 500, null);
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred." + e.toString(), 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
