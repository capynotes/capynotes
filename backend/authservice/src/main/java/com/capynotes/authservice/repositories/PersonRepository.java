package com.capynotes.authservice.repositories;

import com.capynotes.authservice.models.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PersonRepository extends JpaRepository<Person, Long> {
    @Query("SELECT p FROM Person p WHERE p.email=?1")
    Optional<Person> findPersonByEmail(String email);
}
