package com.capynotes.authservice.services;

import org.springframework.stereotype.Service;

@Service
public interface AuthService {
    Long extractId(String token);
    String extractEmail(String token);
}
