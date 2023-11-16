package com.capynotes.authservice.services;

import com.capynotes.authservice.models.Person;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface PersonService {
    String hashPassword(String password);
    Person addPerson(Person person);
    List<Person> findAllPersons();
    Person findPersonById(Long id);
    Person findPersonByEmail(String email);
    void deletePersonById(Long id);
    void save(Person person);
    Person editPerson(Person person);
    void changePassword(Long id, String password);
    boolean isValid(String password);
    boolean pwMatches(String oldPassword, String currentPassword);
    String createRandomPassword();
}
