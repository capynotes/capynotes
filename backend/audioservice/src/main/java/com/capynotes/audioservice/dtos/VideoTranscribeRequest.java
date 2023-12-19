package com.capynotes.audioservice.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class VideoTranscribeRequest {
    private String videoUrl;
    private String noteName;
}

