package com.capynotes.noteservice.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Entity
@Table(name = "transcript")
@NoArgsConstructor
public class Transcript {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long note_id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String transcription;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = false)
    private List<Timestamp> timestamps;
}
