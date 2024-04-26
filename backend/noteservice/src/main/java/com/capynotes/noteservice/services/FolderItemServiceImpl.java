package com.capynotes.noteservice.services;

import com.capynotes.noteservice.dtos.NoteGrid;
import com.capynotes.noteservice.models.FolderItem;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.repositories.FolderItemRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class FolderItemServiceImpl implements FolderItemService {
    private final FolderItemRepository folderItemRepository;
    public FolderItemServiceImpl(FolderItemRepository folderItemRepository) {
        this.folderItemRepository = folderItemRepository;
    }
    @Override
    public FolderItem addFolderItem(FolderItem folderItem) {
        return folderItemRepository.save(folderItem);
    }

    @Override
    public List<Object> getFolderItemsOfUser(Long userId) {
        List<Object> processedItems = new ArrayList<>();
        List<FolderItem> items = folderItemRepository.getFolderItemsOfUser(userId);
        for(FolderItem item: items) {
            if(item instanceof Note) {
                NoteGrid noteGrid = new NoteGrid((Note) item);
                processedItems.add(noteGrid);
            } else {
                processedItems.add(item);
            }
        }
        return processedItems;
        //return folderItemRepository.getFolderItemsOfUser(userId);
    }

    @Override
    public FolderItem getFolderItem(Long id) {
        Optional<FolderItem> item = folderItemRepository.findById(id);
        if(item.isPresent()) {
            return item.get();
        } else {
            return null;
        }
    }

    @Override
    public void deleteFolderItem(Long id) {
        Optional<FolderItem> item = folderItemRepository.findById(id);
        if(item.isPresent()) {
            folderItemRepository.deleteById(id);
        } else {
            throw new RuntimeException("FolderItem with id " + id + "doesn't exist.");
        }
    }
}
