package com.capynotes.authservice.controllers;

import com.capynotes.authservice.config.JwtUtils;
import com.capynotes.authservice.dtos.AuthRequest;
import com.capynotes.authservice.dtos.PersonDto;
import com.capynotes.authservice.models.Person;
import com.capynotes.authservice.services.AuthService;
import com.capynotes.authservice.services.PersonService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/auth")
public class AuthController {
    private final PersonService personService;
    private final JwtUtils jwtUtils;
    private final AuthService authService;

    public AuthController(PersonService personService, JwtUtils jwtUtils, AuthService authService) {
        this.personService = personService;
        this.jwtUtils = jwtUtils;
        this.authService = authService;
    }

    @CrossOrigin(origins = "*")
    @PostMapping("/authenticate")
    public ResponseEntity<?> authenticate(@RequestBody AuthRequest authRequest) {
        try {
            Person person = personService.findPersonByEmail(authRequest.getEmail());
            if(!personService.pwMatches(authRequest.getPassword(), person.getPassword())) {
                return new ResponseEntity<>("Incorrect email or password.", HttpStatus.NOT_ACCEPTABLE);
            }
            //String token = jwtUtils.generateToken(person.getId(), person.getEmail());
            PersonDto personDto = new PersonDto(person);
            return new ResponseEntity<>(personDto, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/id")
    public ResponseEntity<Long> getUserId(@RequestHeader("Authorization") String token) {
        try {
            Long id = authService.extractId(token);
            return new ResponseEntity<>(id, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin(origins = "*")
    @GetMapping("/email")
    public ResponseEntity<String> getUserEmail(@RequestHeader("Authorization") String token) {
        try {
            String email = authService.extractEmail(token);
            return new ResponseEntity<>(email, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
