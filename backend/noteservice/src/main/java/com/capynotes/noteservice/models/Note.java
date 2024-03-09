package com.capynotes.noteservice.models;

import com.capynotes.noteservice.enums.NoteStatus;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "note")
@NoArgsConstructor
public class Note {

    public Note(String title, Long userId, String audioName, LocalDateTime audioUploadTime, NoteStatus status){
        this.title = title;
        this.userId = userId;
        this.audioName = audioName;
        this.audioUploadTime = audioUploadTime;
        this.status = status;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String title;

    private String pdfUrl;

    private Long userId;
    
    private String audioName;

    private LocalDateTime audioUploadTime;

    @OneToMany(mappedBy = "note", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FlashcardSet> cardSets;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private NoteStatus status;
}
