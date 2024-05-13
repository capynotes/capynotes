package com.capynotes.noteservice.dtos;

import com.capynotes.noteservice.models.Folder;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class FolderWithCount {
    private Long id;
    private String title;
    private int folderCount;
    private int noteCount;
    private List<String> searchFilters;
    private final String type = "F";
}
