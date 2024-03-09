package com.capynotes.noteservice.dtos;

import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.models.Summary;
import com.capynotes.noteservice.models.Transcript;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class NoteDto {
    private Note note;
    private Transcript transcript;
    private Summary summary;
}
