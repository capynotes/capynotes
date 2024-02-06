package com.capynotes.noteservice.models;

import com.capynotes.noteservice.enums.NoteStatus;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "note")
public class Note {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    private String url;

    private Long userId;

    private LocalDateTime uploadTime;

    @OneToMany(mappedBy = "note", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FlashcardSet> cardSets;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private NoteStatus status;
}
