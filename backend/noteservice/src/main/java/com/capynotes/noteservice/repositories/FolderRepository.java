package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.Folder;
import com.capynotes.noteservice.models.FolderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FolderRepository extends JpaRepository<Folder, Long> {
    @Query(nativeQuery = true, value = "SELECT id, item_type FROM note WHERE user_id=:userId AND parent_folder_id IS NULL")
    List<Object[]> getMainFoldersAndNotesOfUser(Long userId);
}
