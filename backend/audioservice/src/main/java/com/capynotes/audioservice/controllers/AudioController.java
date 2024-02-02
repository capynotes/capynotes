package com.capynotes.audioservice.controllers;

import java.io.FileNotFoundException;
import java.util.List;

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
            Audio newAudio = audioService.uploadAudioFromFile(file, userId);
            newAudio = audioService.updateAudioStatus(newAudio.getId(), AudioStatus.PENDING);
            // TODO: Maybe move this to service etc.
            // Send request to S2T service
            String transcribeUrl = "http://localhost:5000/transcribe";
            TranscribeRequest transcribeRequest = new TranscribeRequest(newAudio.getName());

            HttpEntity<?> requestEntity = new HttpEntity<>(transcribeRequest);
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<TranscribeResponse> transcribeResponse = restTemplate.exchange(transcribeUrl, HttpMethod.POST,
                    requestEntity,
                    TranscribeResponse.class);

            if (transcribeResponse.getStatusCode() == HttpStatus.OK) {
                TranscribeResponse body = transcribeResponse.getBody();
                newAudio = audioService.updateAudioTranscription(newAudio.getId(), body.getTranscription());
                newAudio = audioService.updateAudioStatus(newAudio.getId(), AudioStatus.DONE);
            } else {
                response = new Response("An error occurred.", 500, null);
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }
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
                response = new Response("An error occurred during summarization.", 500, null);
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }

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
