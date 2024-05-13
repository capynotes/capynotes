package com.capynotes.noteservice.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.antlr.v4.runtime.misc.Pair;

import java.util.ArrayList;
import java.util.List;
@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@DiscriminatorValue(value = "F")
public class Folder extends FolderItem {
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "parent_folder_id")
    private List<FolderItem> items;

    public Pair<Integer, Integer> countFoldersAndNotes() {
        int folderCount = 0;
        int noteCount = 0;

        for (FolderItem item : items) {
            if (item instanceof Folder) {
                folderCount++;
                Pair<Integer, Integer> counts = ((Folder) item).countFoldersAndNotes();
                folderCount += counts.a;
                noteCount += counts.b;
            }
            else if (item instanceof Note) {
                noteCount++;
            }
        }

        return new Pair<>(folderCount, noteCount);
    }

    public List<String> findSearchFilters() {
        List<String> searchFilters = new ArrayList<>();
        for (FolderItem item : items) {
            if (item instanceof Folder) {
                searchFilters.addAll(((Folder) item).findSearchFilters());
            }
            else if (item instanceof Note) {
                Note note = (Note) item;
                for (Tag tag: note.getTags()) {
                    if(!searchFilters.contains(tag.getName())) {
                        searchFilters.add(tag.getName());
                    }
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
        return searchFilters;
    }
}
