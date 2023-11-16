package com.capynotes.authservice.repositories;

import com.capynotes.authservice.models.Person;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import java.util.Collections;

@Repository
public class UserRepository {
    private final PersonRepository personRepository;

    public UserRepository(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    public UserDetails findUserByEmail(String email) {
        Person person = personRepository.findPersonByEmail(email).orElse(null);
        User user = new User(
                person.getEmail(), person.getPassword(), Collections.singleton(new SimpleGrantedAuthority(person.getRole())
        ));
        return user;
    }
}
