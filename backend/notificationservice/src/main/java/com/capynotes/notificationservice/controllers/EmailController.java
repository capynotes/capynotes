package com.capynotes.notificationservice.controllers;

import com.capynotes.notificationservice.dtos.ForgotPasswordRequest;
import com.capynotes.notificationservice.dtos.Response;
import com.capynotes.notificationservice.models.EmailDetails;
import com.capynotes.notificationservice.services.EmailService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("api/mail")
public class EmailController {
    private final EmailService emailService;

    public EmailController(EmailService emailService) {
        this.emailService = emailService;
    }

    @CrossOrigin(origins = "*")
    @PostMapping("/send-forgot-password")
    public ResponseEntity<?> sendForgotPasswordMail(@RequestBody ForgotPasswordRequest forgotPasswordRequest) {
        Response response;
        try {
            String subject = "[CapyNotes] Forgot Password";
            String body = "We heard that you lost your CapyNotes password. Sorry about that!\n" +
                    "But don’t worry! We have assigned you a new random password.\n\n" +
                    "New Password:   " + forgotPasswordRequest.getRandomPassword() + "\n\n" +
                    "Please change this password once you login to CapyNotes.\n" +
                    "Thanks,\nThe CapyNotes Team";
            EmailDetails emailDetails = new EmailDetails(null, forgotPasswordRequest.getEmail(), subject, body, null);
            emailService.sendMail(emailDetails);
            response = new Response("Email sent.", 200, emailDetails);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred while sending mail.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
