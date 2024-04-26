package com.capynotes.noteservice.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.antlr.v4.runtime.misc.Pair;

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
}
