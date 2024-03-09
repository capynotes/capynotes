package com.capynotes.noteservice.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@Table(name = "summary")
@NoArgsConstructor
public class Summary {
    @Id
    private Long id;

    private Long note_id;

    private String summary;
}
