package com.capynotes.noteservice.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CrossReference {
    private Long userId;
    private Long currentNoteId;
    private String tag;
}
