package com.capynotes.noteservice.dtos;

import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.models.Flashcard;
import com.capynotes.noteservice.models.FlashcardSet;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.models.Tag;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
public class NoteGrid {
    private Long id;
    private String title;
    private LocalDateTime creationTime;
    private NoteStatus status;
    private List<String> searchFilters;

    public NoteGrid(Note note) {
        this.id = note.getId();
        this.title = note.getTitle();
        this.creationTime = note.getAudioUploadTime();
        this.status = note.getStatus();

        for (Tag tag: note.getTags()) {
            searchFilters.add(tag.getName());
        }

        for (FlashcardSet set: note.getCardSets()) {
            for (Flashcard flashcard: set.getCards()) {
                if(!searchFilters.contains(flashcard.getFront())) {
                    searchFilters.add(flashcard.getFront());
                }
            }
        }
    }
}
