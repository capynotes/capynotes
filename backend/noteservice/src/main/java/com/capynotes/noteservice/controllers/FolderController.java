package com.capynotes.noteservice.controllers;

import com.capynotes.noteservice.dtos.FolderWithCount;
import com.capynotes.noteservice.dtos.Response;
import com.capynotes.noteservice.models.Folder;
import com.capynotes.noteservice.services.FolderService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/folder")
public class FolderController {
    FolderService folderService;
    public FolderController(FolderService folderService) {
        this.folderService = folderService;
    }

    @PostMapping("/add")
    public Response addFolder(@RequestBody Folder folder) {
        try {
            Folder createdItem = folderService.addFolder(folder);
            return new Response("Success", 200, createdItem);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @GetMapping("/main/{id}")
    public Response getMainFoldersOfUser(@PathVariable("id") long id) {
        try {
            List<FolderWithCount> items = folderService.getMainFoldersOfUser(id);
            return new Response("Success", 200, items);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @GetMapping("/{id}")
    public Response getFolderContentById(@PathVariable("id") long id) {
        try {
            List<Object> content = folderService.getFolder(id);
            return new Response("Success", 200, content);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @DeleteMapping("/{id}")
    public Response deleteFolderById(@PathVariable("id") long id) {
        try {
            folderService.deleteFolder(id);
            return new Response("Success", 200, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }

    @PostMapping("/add-to-folder/{id}")
    public Response addFolderToFolder(@RequestBody Folder folder, @PathVariable("id") long folderId) {
        try {
            if(folderService.addFolderItemToFolder(folder, folderId))
                return new Response("Success", 200, folder);
            return new Response("Could not add folder in folder", 200, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Response("Exception", 500, null);
        }
    }
}
