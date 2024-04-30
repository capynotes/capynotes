package com.capynotes.noteservice.dtos;

import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.models.*;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
public class NoteGrid {
    private Long id;
    private String title;
    private LocalDateTime creationTime;
    private NoteStatus status;
    private List<String> searchFilters;
    private final String type = "N";

    public NoteGrid(Note note) {
        searchFilters = new ArrayList<>();

        this.id = note.getId();
        this.title = note.getTitle();
        this.creationTime = note.getCreationTime();
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
