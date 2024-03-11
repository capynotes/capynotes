package com.capynotes.noteservice.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class VideoTranscribeRequest {
    private String videoUrl;
    private String noteName;
    private Long userId;
}