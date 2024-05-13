package com.capynotes.noteservice.models;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "flashcard")
public class Flashcard {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT")
    private String front;

    @Column(columnDefinition = "TEXT")
    private String back;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "set_id")
    private FlashcardSet set;

    public void edit(Flashcard newFlashcard) {
        this.front = newFlashcard.getFront();
        this.back = newFlashcard.getBack();
    }
}
