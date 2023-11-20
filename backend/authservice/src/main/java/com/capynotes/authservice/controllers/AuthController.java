package com.capynotes.authservice.controllers;

import com.capynotes.authservice.services.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
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
