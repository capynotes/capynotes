package com.capynotes.noteservice.models;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "flashcard")
public class Flashcard {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String front;

    private String back;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "set_id")
    private FlashcardSet set;

    public void edit(Flashcard newFlashcard) {
        this.front = newFlashcard.getFront();
        this.back = newFlashcard.getBack();
    }
}
