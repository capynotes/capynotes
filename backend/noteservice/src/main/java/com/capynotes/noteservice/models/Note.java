package com.capynotes.noteservice.models;

import com.capynotes.noteservice.enums.NoteStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
//@Table(name = "note")
@NoArgsConstructor
@AllArgsConstructor
@DiscriminatorValue(value = "N")
public class Note extends FolderItem {

    public Note(String title, Long userId, String audioKey, LocalDateTime creationTime, NoteStatus status){
        //this.title = title;
        //this.userId = userId;
        super(title, userId);
        this.audioKey = audioKey;
        this.creationTime = creationTime;
        this.status = status;
    }

    public Note(String title, Long userId, LocalDateTime creationTime, NoteStatus status) {
        super(title, userId);
        this.creationTime = creationTime;
        this.status = status;
    }

    /*@Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String title;*/

    private String pdfKey;

    //private Long userId;
    
    private String audioKey;

    private LocalDateTime creationTime;

    @OneToMany(mappedBy = "note", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FlashcardSet> cardSets;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private NoteStatus status;

    @OneToMany(mappedBy = "note", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Tag> tags;
}
