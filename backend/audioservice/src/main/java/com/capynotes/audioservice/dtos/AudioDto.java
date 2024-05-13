package com.capynotes.audioservice.dtos;

import java.time.LocalDateTime;

import com.capynotes.audioservice.models.Audio;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AudioDto {
    public AudioDto(Audio audio) {
        this.id = audio.getId();
        this.name = audio.getName();
        this.url = audio.getUrl();
        this.userId = audio.getUserId();
        this.uploadTime = audio.getUploadTime();
        this.transcription = audio.getTranscription();
        this.summary = audio.getSummary();
    }

    private Long id;
    private String name;
    private String url;
    private Long userId;
    private LocalDateTime uploadTime;
    private String transcription;
    private String summary;

}
