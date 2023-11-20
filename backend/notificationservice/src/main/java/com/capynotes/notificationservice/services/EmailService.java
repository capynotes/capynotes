package com.capynotes.notificationservice.services;

import com.capynotes.notificationservice.models.EmailDetails;
import org.springframework.stereotype.Service;

@Service
public interface EmailService {
    String sendMail(EmailDetails emailDetails);
    String sendMailWithAttachments(EmailDetails emailDetails);
}
