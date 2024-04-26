package com.capynotes.noteservice.services;

import com.capynotes.noteservice.dtos.FolderWithCount;
import com.capynotes.noteservice.dtos.NoteGrid;
import com.capynotes.noteservice.models.Folder;
import com.capynotes.noteservice.models.FolderItem;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.repositories.FolderRepository;
import org.antlr.v4.runtime.misc.Pair;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class FolderServiceImpl implements FolderService {
    private final FolderRepository folderRepository;
    public FolderServiceImpl(FolderRepository folderRepository) {
        this.folderRepository = folderRepository;
    }
    @Override
    public Folder addFolder(Folder folder) {
        return folderRepository.save(folder);
    }

    @Override
    public List<FolderWithCount> getMainFoldersOfUser(Long userId) {
        List<FolderWithCount> fwcs = new ArrayList<>();
        List<Folder> folders = folderRepository.getMainFoldersOfUser(userId);
        for(Folder folder: folders) {
            Pair<Integer, Integer> counts = folder.countFoldersAndNotes();
            fwcs.add(new FolderWithCount(folder.getId(), folder.getTitle(), counts.a, counts.b));
        }
        return fwcs;
    }

    @Override
    public List<Object> getFolder(Long id) {
        Optional<Folder> folderOpt = folderRepository.findById(id);
        if(folderOpt.isPresent()) {
            Folder folder = folderOpt.get();
            List<Object> processedItems = new ArrayList<>();
            List<FolderItem> items = folder.getItems();
            for(FolderItem item: items) {
                if(item instanceof Note) {
                    NoteGrid noteGrid = new NoteGrid((Note) item);
                    processedItems.add(noteGrid);
                } else {
                    Folder itemIsFolder = (Folder) item;
                    Pair<Integer, Integer> counts = itemIsFolder.countFoldersAndNotes();
                    FolderWithCount fwc = new FolderWithCount(item.getId(), item.getTitle(), counts.a, counts.b);
                    processedItems.add(fwc);
                }
            }
            return processedItems;
        } else {
            throw new RuntimeException("Folder with id " + id + "doesn't exist.");
        }
    }

    @Override
    public void deleteFolder(Long id) {
        Optional<Folder> item = folderRepository.findById(id);
        if(item.isPresent()) {
            folderRepository.deleteById(id);
        } else {
            throw new RuntimeException("Folder with id " + id + "doesn't exist.");
        }
    }

    @Override
    public boolean addFolderItemToFolder(FolderItem folderItem, Long id) {
        Optional<Folder> folderOpt = folderRepository.findById(id);
        if(folderOpt.isPresent()) {
            Folder folder = folderOpt.get();
            folder.getItems().add(folderItem);
            folderRepository.save(folder);
            return true;
        } else {
            return false;
        }
    }
}
