package com.capynotes.audioservice.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

import com.capynotes.audioservice.enums.AudioStatus;

@Data
@Entity
@Table(name = "audio")
@NoArgsConstructor
public class Audio {

    public Audio(String name, String url, Long userId, LocalDateTime uploadTime, String transcription, AudioStatus status, String summary) {
        this.name = name;
        this.url = url;
        this.userId = userId;
        this.uploadTime = uploadTime;
        this.transcription = transcription;
        this.status = status;
        this.summary = summary;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    @Column(unique = true)
    private String url;

    private Long userId;

    private LocalDateTime uploadTime;
    
    @Column(columnDefinition = "TEXT")
    private String transcription;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private AudioStatus status;

    @Column(columnDefinition = "TEXT")
    private String summary;
}
