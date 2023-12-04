package com.capynotes.audioservice.services;

import com.capynotes.audioservice.enums.AudioStatus;
import com.capynotes.audioservice.exceptions.FileDownloadException;
import com.capynotes.audioservice.exceptions.FileUploadException;
import com.capynotes.audioservice.models.Audio;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

@Service
public interface AudioService {
    Audio uploadAudio(MultipartFile multipartFile, Long userId) throws IOException, FileUploadException;
    Object downloadAudio(String fileName) throws IOException, FileDownloadException;
    List<Audio> findAudioByUserId(Long userId) throws FileNotFoundException;
    Audio updateAudioTranscription(Long audioId, String transcription);
    Audio updateAudioStatus(Long audioId, AudioStatus status);
}
