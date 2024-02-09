package com.capynotes.noteservice.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class NoteRequest {
    private String name;
    private String summary;
}
