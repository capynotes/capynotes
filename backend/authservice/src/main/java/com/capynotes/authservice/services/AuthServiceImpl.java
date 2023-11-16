package com.capynotes.authservice.services;

import com.capynotes.authservice.config.JwtUtils;
import org.springframework.stereotype.Service;

@Service
public class AuthServiceImpl implements AuthService {
    JwtUtils jwtUtils;

    public AuthServiceImpl(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }
    @Override
    public Long extractId(String token) {
        String jwtToken = token.replace("Bearer ", "");
        return jwtUtils.extractId(jwtToken);
    }

    @Override
    public String extractEmail(String token) {
        String jwtToken = token.replace("Bearer ", "");
        return jwtUtils.extractEmail(jwtToken);
    }
}
