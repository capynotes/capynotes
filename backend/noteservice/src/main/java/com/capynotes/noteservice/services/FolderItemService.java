package com.capynotes.noteservice.services;

import com.capynotes.noteservice.models.FolderItem;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FolderItemService {
    FolderItem addFolderItem(FolderItem folderItem);
    List<Object> getFolderItemsOfUser(Long userId);
    FolderItem getFolderItem(Long id);
    void deleteFolderItem(Long id);
}
