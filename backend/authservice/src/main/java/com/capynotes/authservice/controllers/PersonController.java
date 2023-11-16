package com.capynotes.authservice.controllers;

import com.capynotes.authservice.config.JwtUtils;
import com.capynotes.authservice.dtos.ChangePasswordDto;
import com.capynotes.authservice.dtos.PersonDto;
import com.capynotes.authservice.models.Person;
import com.capynotes.authservice.services.AuthService;
import com.capynotes.authservice.services.PersonService;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("api/person")
public class PersonController {

    JwtUtils jwtUtils;
    PersonService personService;
    AuthService authService;

    public PersonController(PersonService personService, JwtUtils jwtUtils, AuthService authService) {
        this.personService = personService;
        this.jwtUtils = jwtUtils;
        this.authService = authService;
    }

    @CrossOrigin(origins = "*")
    @PostMapping
    public ResponseEntity<?> addPerson(@RequestBody Person person) {
        try {
            if(!personService.isValid(person.getPassword())) {
                return new ResponseEntity<>("Password must have at least 6 alphanumeric characters.", HttpStatus.NOT_ACCEPTABLE);
            }
            if(!isValidEmail(person.getEmail())) {
                return new ResponseEntity<>("Please enter a valid email address.", HttpStatus.NOT_ACCEPTABLE);
            }

            Person createdPerson = personService.addPerson(person);

            //final String url = "http://localhost:8080/api/mail/verify/" + createdPerson.getId();
            //sendMail(url);

            return new ResponseEntity<>(createdPerson, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/all")
    public ResponseEntity<List<Person>> getAllPersons() {
        try {
            List<Person> persons = personService.findAllPersons();
            return new ResponseEntity<>(persons, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/{id}")
    public ResponseEntity<?> getPersonById(@PathVariable("id") long id) {
        try {
            PersonDto personDto = new PersonDto(personService.findPersonById(id));
            return new ResponseEntity<>(personDto, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Person could not be found.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping
    public ResponseEntity<?> getPersonByEmail(@RequestParam("email") String email) {
        try {
            PersonDto personDto = new PersonDto(personService.findPersonByEmail(email));
            return new ResponseEntity<>(personDto, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Person could not be found.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePersonById(@PathVariable("id") long id) {
        try {
            personService.deletePersonById(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @PutMapping
    public ResponseEntity<?> editPerson(@RequestBody Person person) {
        return null;
    }

    @CrossOrigin(origins = "*")
    @PutMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestBody ChangePasswordDto changePasswordDto) {
        try {
            Person person = personService.findPersonById(changePasswordDto.getId());
            if(!personService.pwMatches(changePasswordDto.getOldPassword(), person.getPassword())) {
                return new ResponseEntity<>("Old password is wrong.", HttpStatus.NOT_ACCEPTABLE);
            }
            if(!personService.isValid(changePasswordDto.getNewPassword())) {
                return new ResponseEntity<>("Password must have at least 6 alphanumeric characters.", HttpStatus.NOT_ACCEPTABLE);
            }
            //Long id = authService.extractId(token);
            personService.changePassword(changePasswordDto.getId(), changePasswordDto.getNewPassword());
            return new ResponseEntity<>("Password changed.", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody String email) {
        String randomPw = personService.createRandomPassword();
        //mail atılacak
        return new ResponseEntity<>(randomPw, HttpStatus.OK);
    }
    private void sendMail(String url) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            restTemplate.exchange(url, HttpMethod.POST, null, String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private boolean isValidEmail(String email) {
        return email.contains("@");
    }
}
