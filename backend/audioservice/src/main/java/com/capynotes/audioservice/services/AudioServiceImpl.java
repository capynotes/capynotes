package com.capynotes.audioservice.services;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import com.capynotes.audioservice.dtos.VideoTranscribeRequest;
import com.capynotes.audioservice.dtos.VideoTranscribeResponse;
import com.capynotes.audioservice.enums.AudioStatus;
import com.capynotes.audioservice.exceptions.FileDownloadException;
import com.capynotes.audioservice.exceptions.FileUploadException;
import com.capynotes.audioservice.models.Audio;
import com.capynotes.audioservice.repositories.AudioRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.time.LocalDateTime;
import java.util.*;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class AudioServiceImpl implements AudioService {

    @Value("${aws.bucket.name}")
    private String bucketName;

    private final AmazonS3 amazonS3;
    AudioRepository audioRepository;

    public AudioServiceImpl(AmazonS3 amazonS3, AudioRepository audioRepository) {
        this.amazonS3 = amazonS3;
        this.audioRepository = audioRepository;
    }

    @Override
    public Audio uploadAudioFromFile(MultipartFile multipartFile, Long userId) throws IOException, FileUploadException {
        String fileName = UUID.randomUUID().toString() + "_" + multipartFile.getOriginalFilename();
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(multipartFile.getSize());
        try {
            amazonS3.putObject(new PutObjectRequest(bucketName, fileName, multipartFile.getInputStream(), metadata));
        } catch (Exception e) {
            throw new FileUploadException("Could not upload the file!" + e.toString());
        }

        String url = amazonS3.getUrl(bucketName, fileName).toString();
        LocalDateTime dateTime = LocalDateTime.now();
        Audio audio = new Audio(fileName, url, userId, dateTime, null, AudioStatus.NO_REQUEST, null);
        audioRepository.save(audio);
        return audio;
    }

    // @Override
    public Audio uploadAudioFromURL(String videoUrl, String fileName, Long userId) {
        String newName = UUID.randomUUID().toString() + "_" + fileName;
        // Send request to Flask, it uploads the file to S3, generates the transcript, returns S3 url and transcript
        LocalDateTime uploadTime = LocalDateTime.now();
        String url = "http://localhost:5000/youtube";
        VideoTranscribeRequest transcribeRequest = new VideoTranscribeRequest(videoUrl, newName);
        Audio newAudio = new Audio(newName, null, userId, uploadTime, null, AudioStatus.PENDING, null);
        audioRepository.save(newAudio);

        HttpEntity<?> requestEntity = new HttpEntity<>(transcribeRequest);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<VideoTranscribeResponse> transcribeResponse = restTemplate.exchange(url, HttpMethod.POST,
                requestEntity,
                VideoTranscribeResponse.class);

        if (transcribeResponse.getStatusCode() == HttpStatus.OK) {
            VideoTranscribeResponse body = transcribeResponse.getBody();
            newAudio = updateAudioTranscription(newAudio.getId(), body.getTranscription());
            newAudio = updateAudioStatus(newAudio.getId(), AudioStatus.DONE);
            URL fileUrl = amazonS3.getUrl(bucketName, newAudio.getName());
            newAudio = updateAudioURL(newAudio.getId(), fileUrl.toString());
        } else {
            //TODO: Handle error
            newAudio = updateAudioStatus(newAudio.getId(), AudioStatus.ERROR);
        }
        return newAudio;
    }

    @Override
    public Object downloadAudio(String fileName) throws IOException, FileDownloadException {
        if (bucketIsEmpty()) {
            throw new FileDownloadException("Requested bucket does not exist or is empty");
        }
        S3Object object = amazonS3.getObject(bucketName, fileName);
        try (S3ObjectInputStream s3is = object.getObjectContent()) {
            try (FileOutputStream fileOutputStream = new FileOutputStream(fileName)) {
                byte[] read_buf = new byte[1024];
                int read_len = 0;
                while ((read_len = s3is.read(read_buf)) > 0) {
                    fileOutputStream.write(read_buf, 0, read_len);
                }
            }
            Path pathObject = Paths.get(fileName);
            Resource resource = new UrlResource(pathObject.toUri());

            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new FileDownloadException("Could not find the file!");
            }
        }
    }

    @Override
    public List<Audio> findAudioByUserId(Long userId) throws FileNotFoundException {
        Optional<List<Audio>> audios = audioRepository.findAudioByUserId(userId);
        if (audios.isEmpty()) {
            throw new FileNotFoundException("User with id " + userId + " does not have any uploaded audios.");
        }
        return audios.get();
    }

    @Override
    public Audio updateAudioTranscription(Long audioId, String transcription) {
        Optional<Audio> optionalAudio = audioRepository.findById(audioId);
        if (optionalAudio.isEmpty()) {
            throw new IllegalArgumentException("Audio with id " + audioId + " does not exist.");
        }
        Audio audio = optionalAudio.get();
        audio.setTranscription(transcription);
        audioRepository.save(audio);
        return audio;
    }

    @Override
    public Audio updateAudioStatus(Long audioId, AudioStatus status) {
        Optional<Audio> optionalAudio = audioRepository.findById(audioId);
        if (optionalAudio.isEmpty()) {
            throw new IllegalArgumentException("Audio with id " + audioId + " does not exist.");
        }
        Audio audio = optionalAudio.get();
        audio.setStatus(status);
        audioRepository.save(audio);
        return audio;
    }

    @Override
    public Audio updateAudioURL(Long audioId, String url) {
        Optional<Audio> optionalAudio = audioRepository.findById(audioId);
        if (optionalAudio.isEmpty()) {
            throw new IllegalArgumentException("Audio with id " + audioId + " does not exist.");
        }
        Audio audio = optionalAudio.get();
        audio.setUrl(url);
        audioRepository.save(audio);
        return audio;
    }
    @Override
    public Audio updateAudioSummary(Long audioId, String summary) {
        Optional<Audio> optionalAudio = audioRepository.findById(audioId);
        if (optionalAudio.isEmpty()) {
            throw new IllegalArgumentException("Audio with id " + audioId + " does not exist.");
        }
        Audio audio = optionalAudio.get();
        audio.setSummary(summary);
        audioRepository.save(audio);
        return audio;
    }

    private boolean bucketIsEmpty() {
        ListObjectsV2Result result = amazonS3.listObjectsV2(this.bucketName);
        if (result == null) {
            return false;
        }
        List<S3ObjectSummary> objects = result.getObjectSummaries();
        return objects.isEmpty();
    }
}
