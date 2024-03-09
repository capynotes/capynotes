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
    private Long id;

    private Long note_id;

    private String transcription;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Timestamp> timestamps;
}
