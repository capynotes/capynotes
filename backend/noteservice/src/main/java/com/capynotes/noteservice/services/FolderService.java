package com.capynotes.noteservice.services;

import com.capynotes.noteservice.dtos.FolderWithContent;
import com.capynotes.noteservice.dtos.FolderWithCount;
import com.capynotes.noteservice.models.Folder;
import com.capynotes.noteservice.models.FolderItem;
import com.capynotes.noteservice.models.Note;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FolderService {
    Folder addFolder(Folder folder);
    List<Object> getMainFoldersAndNotesOfUser(Long userId);
    FolderWithContent getFolderContent(Long id);
    void deleteFolder(Long id);
    boolean addFolderItemToFolder(FolderItem folderItem, Long id);
}
