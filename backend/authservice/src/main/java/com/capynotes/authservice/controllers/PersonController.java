package com.capynotes.authservice.controllers;

import com.capynotes.authservice.config.JwtUtils;
import com.capynotes.authservice.dtos.*;
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
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequest authRequest) {
        Response response;
        try {
            Person person = personService.findPersonByEmail(authRequest.getEmail());
            if(!personService.pwMatches(authRequest.getPassword(), person.getPassword())) {
                response = new Response("Incorrect email or password.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            String token = jwtUtils.generateToken(person.getId(), person.getEmail());
            PersonDto personDto = new PersonDto(person, token);
            response = new Response("Login successful.", 200, personDto);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @CrossOrigin(origins = "*")
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Person person) {
        Response response;
        try {
            if(!personService.isValid(person.getPassword())) {
                response = new Response("Password must have at least 6 alphanumeric characters.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if(!isValidEmail(person.getEmail())) {
                response = new Response("Please enter a valid email address.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if(personService.findPersonByEmail(person.getEmail()) != null) {
                response = new Response("This email is already in use!", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            Person createdPerson = personService.addPerson(person);
            response = new Response("Register successful.", 200, createdPerson);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/all")
    public ResponseEntity<?> getAllPersons() {
        Response response;
        try {
            List<Person> persons = personService.findAllPersons();
            response = new Response("Success.", 200, persons);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/{id}")
    public ResponseEntity<?> getPersonById(@PathVariable("id") long id) {
        Response response;
        try {
            PersonDto personDto = new PersonDto(personService.findPersonById(id), null);
            response = new Response("Person found.", 200, personDto);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("Person could not be found.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping
    public ResponseEntity<?> getPersonByEmail(@RequestParam("email") String email) {
        Response response;
        try {
            PersonDto personDto = new PersonDto(personService.findPersonByEmail(email), null);
            response = new Response("Person found.", 200, personDto);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("Person could not be found.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePersonById(@PathVariable("id") long id) {
        Response response;
        try {
            personService.deletePersonById(id);
            response = new Response("Person deleted.", 200, null);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @PutMapping
    public ResponseEntity<?> editPerson(@RequestBody Person person) {
        return null;
    }

    @CrossOrigin(origins = "*")
    @PutMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestHeader("Authorization") String token, @RequestBody ChangePasswordDto changePasswordDto) {
        Response response;
        try {
            Long id = authService.extractId(token);
            Person person = personService.findPersonById(id);
            if(changePasswordDto.getOldPassword().equals(changePasswordDto.getNewPassword())) {
                response = new Response("New password cannot be the same with old password.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if(!personService.pwMatches(changePasswordDto.getOldPassword(), person.getPassword())) {
                response = new Response("Old password is wrong.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if(!personService.isValid(changePasswordDto.getNewPassword())) {
                response = new Response("Password must have at least 6 alphanumeric characters.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            personService.changePassword(id, changePasswordDto.getNewPassword());
            response = new Response("Password changed.", 200, null);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestParam("email") String email) {
        Response response;
        String randomPw = personService.createRandomPassword();

        Person person = personService.findPersonByEmail(email);
        if (person != null) {
            String url = "http://localhost:8081/api/mail/send-forgot-password";
            ForgotPasswordRequest forgotPasswordRequest = new ForgotPasswordRequest(email, randomPw);

            HttpEntity<?> requestEntity = new HttpEntity<>(forgotPasswordRequest);
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<?> mailResponse = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);

            if(mailResponse.getStatusCode() == HttpStatus.OK) {
                personService.changePassword(person.getId(), randomPw);
            } else {
                response = new Response("Error while sending mail.", mailResponse.getStatusCode().value(), mailResponse.getBody());
                return new ResponseEntity<>(response, mailResponse.getStatusCode());
            }
        } else {
            response = new Response("User with given email is not found.", 200, null);
            return new ResponseEntity<>(response, HttpStatus.OK);
        }
        response = new Response("Mail sent and password changed.", 200, randomPw);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
    private void sendRequest(String url) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            restTemplate.exchange(url, HttpMethod.POST, null, String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean isValidEmail(String email) {
        // TODO
        return email.contains("@");
    }
}
