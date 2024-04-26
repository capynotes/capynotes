package com.capynotes.noteservice.repositories;

import com.capynotes.noteservice.models.FolderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FolderItemRepository extends JpaRepository<FolderItem, Long> {
    @Query("SELECT i FROM FolderItem i WHERE i.userId=?1")
    List<FolderItem> getFolderItemsOfUser(Long userId);
}
