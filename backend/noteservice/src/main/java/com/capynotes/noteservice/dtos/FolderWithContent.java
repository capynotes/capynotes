package com.capynotes.noteservice.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class FolderWithContent {
    private Long id;
    private String title;
    private List<Object> processedItems;
}
