package com.capynotes.audioservice.repositories;

import com.capynotes.audioservice.models.Audio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface AudioRepository extends JpaRepository<Audio, Long> {
    Optional<List<Audio>> findAudioByUserId(Long userId);
}
