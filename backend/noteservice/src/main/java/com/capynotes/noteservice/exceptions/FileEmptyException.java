package com.capynotes.noteservice.exceptions;

public class FileEmptyException extends Exception {
    public FileEmptyException(String message) {
        super(message);
    }
}
