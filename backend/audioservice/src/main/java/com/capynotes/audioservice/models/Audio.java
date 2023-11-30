package com.capynotes.audioservice.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "audio")
@NoArgsConstructor
public class Audio {

    public Audio(String name, String url, Long userId, LocalDateTime uploadTime) {
        this.name = name;
        this.url = url;
        this.userId = userId;
        this.uploadTime = uploadTime;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    @Column(unique = true)
    private String url;

    private Long userId;

    private LocalDateTime uploadTime;
}
