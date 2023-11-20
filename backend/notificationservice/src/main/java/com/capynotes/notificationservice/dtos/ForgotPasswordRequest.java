package com.capynotes.notificationservice.dtos;

import lombok.Data;
@Data
public class ForgotPasswordRequest {
    private String email;
    private String randomPassword;
}
