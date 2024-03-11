package com.capynotes.noteservice.models;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@Table(name = "timestamp")
@NoArgsConstructor
public class Timestamp {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transcription_id")
    private Transcript transcript;
    
    @Column(nullable = false)
    private float start;
    
    @Column(nullable = false)
    private float finish;
    
    @Column(nullable = false, columnDefinition = "TEXT")
    private String phrase;

}
