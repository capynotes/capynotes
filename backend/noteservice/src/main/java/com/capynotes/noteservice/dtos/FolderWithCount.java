package com.capynotes.noteservice.dtos;

import com.capynotes.noteservice.models.Folder;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FolderWithCount {
    private Long id;
    private String title;
    private int folderCount;
    private int noteCount;
}
