package com.capynotes.authservice.services;

import com.capynotes.authservice.models.Person;
import com.capynotes.authservice.repositories.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

@Service
public class PersonServiceImpl implements PersonService {
    private final PersonRepository personRepository;
    private final PasswordEncoder passwordEncoder;

    public PersonServiceImpl(PersonRepository personRepository, PasswordEncoder passwordEncoder) {
        this.personRepository = personRepository;
        this.passwordEncoder = passwordEncoder;
    }
    @Override
    public String hashPassword(String password) {
        return passwordEncoder.encode(password);
    }

    @Override
    public Person addPerson(Person person) {
        String hashedPw = hashPassword(person.getPassword());
        person.setPassword(hashedPw);
        return personRepository.save(person);
    }

    @Override
    public List<Person> findAllPersons() {
        return personRepository.findAll();
    }

    @Override
    public Person findPersonById(Long id) {
        Optional<Person> person = personRepository.findById(id);
        if(person.isPresent()) {
            return person.get();
        } else {
            throw new RuntimeException("User with id " + id + " does not exist.");
        }
    }

    @Override
    public Person findPersonByEmail(String email) {
        Optional<Person> person = personRepository.findPersonByEmail(email);
        if(person.isPresent()) {
            return person.get();
        } else {
            throw new RuntimeException("User with email " + email + " does not exist.");
        }
    }

    @Override
    public void deletePersonById(Long id) {
        Optional<Person> person = personRepository.findById(id);
        if(person.isPresent()) {
            personRepository.deleteById(id);
        } else {
            throw new RuntimeException("User with id " + id + " does not exist.");
        }
    }

    @Override
    public void save(Person person) {
        personRepository.save(person);
    }

    @Override
    public Person editPerson(Person person) {
        return null;
    }

    @Override
    public void changePassword(Long id, String password) {
        Person person = findPersonById(id);
        String hashedPw = hashPassword(password);
        person.setPassword(hashedPw);
        personRepository.save(person);
    }
    @Override
    public boolean isValid(String password) {
        //Pattern pattern = Pattern.compile("^(?:[a-zA-Z\\d]{6,})$");
        //return pattern.matcher(password).matches();
        return password.length() >= 6;
    }
    @Override
    public boolean pwMatches(String oldPassword, String currentPassword) {
        return passwordEncoder.matches(oldPassword, currentPassword);
    }
    @Override
    public String createRandomPassword() {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder newPw = new StringBuilder();
        for(int i = 0; i < 8; i++) {
            int index = random.nextInt(characters.length());
            char randomChar = characters.charAt(index);
            newPw.append(randomChar);
        }
        return newPw.toString();
    }
}
