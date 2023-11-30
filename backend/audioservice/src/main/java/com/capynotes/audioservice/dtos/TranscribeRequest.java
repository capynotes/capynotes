package com.capynotes.audioservice.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TranscribeRequest {
    private String file_name;
}
