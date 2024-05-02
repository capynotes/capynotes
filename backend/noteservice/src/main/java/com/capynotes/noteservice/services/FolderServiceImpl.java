package com.capynotes.noteservice.services;

import com.capynotes.noteservice.dtos.FolderWithContent;
import com.capynotes.noteservice.dtos.FolderWithCount;
import com.capynotes.noteservice.dtos.NoteGrid;
import com.capynotes.noteservice.models.Folder;
import com.capynotes.noteservice.models.FolderItem;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.repositories.FolderRepository;
import com.capynotes.noteservice.repositories.NoteRepository;
import org.antlr.v4.runtime.misc.Pair;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class FolderServiceImpl implements FolderService {
    private final FolderRepository folderRepository;
    private final NoteRepository noteRepository;
    public FolderServiceImpl(FolderRepository folderRepository, NoteRepository noteRepository) {
        this.folderRepository = folderRepository;
        this.noteRepository = noteRepository;
    }
    @Override
    public Folder addFolder(Folder folder) {
        return folderRepository.save(folder);
    }

    @Override
    public List<Object> getMainFoldersAndNotesOfUser(Long userId) {
        List<Object> mainItems = new ArrayList<>();
        /*List<Object[]> objects = folderRepository.getMainFoldersAndNotesOfUser(userId);
        for(Object item: objects) {
            if(item instanceof Folder) {
                Folder itemIsFolder = (Folder) item;
                Pair<Integer, Integer> counts = itemIsFolder.countFoldersAndNotes();
                mainItems.add(new FolderWithCount(itemIsFolder.getId(), itemIsFolder.getTitle(), counts.a, counts.b));
            } else {
                NoteGrid noteGrid = new NoteGrid((Note) item);
                mainItems.add(noteGrid);
            }
        }*/
        try {
            List<Object[]> objects = folderRepository.getMainFoldersAndNotesOfUser(userId);
            for(Object[] itemArray: objects) {
                String itemType = (String) itemArray[1];
                if("F".equals(itemType)) {
                    Folder folder = getFolderById((Long) itemArray[0]);
                    if(folder != null) {
                        Pair<Integer, Integer> counts = folder.countFoldersAndNotes();
                        mainItems.add(new FolderWithCount(folder.getId(), folder.getTitle(), counts.a, counts.b, folder.findSearchFilters()));
                    }
                } else {
                    Note note = getNoteById((Long) itemArray[0]);
                    if(note != null) {
                        NoteGrid noteGrid = new NoteGrid(note);
                        mainItems.add(noteGrid);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting folder/note from db.");
        }

        return mainItems;
    }

    @Override
    public FolderWithContent getFolderContent(Long id) {
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
                    FolderWithCount fwc = new FolderWithCount(item.getId(), item.getTitle(), counts.a, counts.b, itemIsFolder.findSearchFilters());
                    processedItems.add(fwc);
                }
            }
            return new FolderWithContent(folder.getId(), folder.getTitle(), processedItems);
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

    private Folder getFolderById(Long id) {
        Optional<Folder> item = folderRepository.findById(id);
        if(item.isPresent()) {
            return item.get();
        } else {
            return null;
        }
    }

    private Note getNoteById(Long id) {
        Optional<Note> item = noteRepository.findById(id);
        if(item.isPresent()) {
            return item.get();
        } else {
            return null;
        }
    }
}
