package com.capynotes.noteservice.controllers;

import com.capynotes.noteservice.dtos.Response;
import com.capynotes.noteservice.models.Flashcard;
import com.capynotes.noteservice.models.FlashcardSet;
import com.capynotes.noteservice.services.FlashcardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/flashcard")
public class FlashcardController {
    FlashcardService flashcardService;
    public FlashcardController(FlashcardService flashcardService) {
        this.flashcardService = flashcardService;
    }
    @PostMapping("/add")
    public ResponseEntity<?> addFlashcard(@RequestBody Flashcard flashcard) {
        Response response;
        try {
            if(flashcard.getBack() == null || flashcard.getFront() == null) {
                response = new Response("Front or back of flashcard is null.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            flashcardService.addFlashcard(flashcard);
            response = new Response("Flashcard added.", 200, flashcard);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> getFlashcardById(@PathVariable("id") long id) {
        Response response;
        try {
            Flashcard flashcard = flashcardService.findFlashcardById(id);
            response = new Response("Flashcard found.", 200, flashcard);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("Flashcard could not be found.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteFlashcardById(@PathVariable("id") long id) {
        Response response;
        try {
            flashcardService.deleteFlashcardById(id);
            response = new Response("Flashcard deleted.", 200, null);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @PutMapping("/edit")
    public ResponseEntity<?> editFlashcard(@RequestBody Flashcard flashcard) {
        Response response;
        try {
            if(flashcard.getBack() == null || flashcard.getFront() == null) {
                response = new Response("Front or back of flashcard is null.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            Flashcard old = flashcardService.findFlashcardById(flashcard.getId());
            flashcardService.editFlashcard(flashcard, old);
            response = new Response("Flashcard edited.", 200, flashcard);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @PostMapping("/add-set")
    public ResponseEntity<?> addFlashcardSet(@RequestBody FlashcardSet flashcardSet) {
        Response response;
        try {
            if(flashcardSet.getTitle() == null) {
                response = new Response("Flashcard Set needs a title.", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if(flashcardSet.getNote() == null) {
                response = new Response("Flashcard Set must belong to a note", 406, null);
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            flashcardService.createSet(flashcardSet);
            response = new Response("Flashcard Set created.", 200, flashcardSet);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/set/{id}")
    public ResponseEntity<?> getFlashcardSetById(@PathVariable("id") long id) {
        Response response;
        try {
            FlashcardSet flashcardSet = flashcardService.getFlashcardSet(id);
            response = new Response("Flashcard Set found.", 200, flashcardSet);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("Flashcard Set could not be found.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/set/user/{id}")
    public ResponseEntity<?> getFlashcardSetOfUser(@PathVariable("id") long id) {
        Response response;
        try {
            List<FlashcardSet> flashcardSets = flashcardService.getFlashcardSetsOfUser(id);
            response = new Response("Flashcard Sets of user found.", 200, flashcardSets);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("Flashcard Sets could not be found.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/set/note/{id}")
    public ResponseEntity<?> getFlashcardSetOfNote(@PathVariable("id") long id) {
        Response response;
        try {
            List<FlashcardSet> flashcardSets = flashcardService.getFlashcardSetsOfNote(id);
            response = new Response("Flashcard Sets of note found.", 200, flashcardSets);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("Flashcard Sets could not be found.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @DeleteMapping("/set/{id}")
    public ResponseEntity<?> deleteFlashcardSetById(@PathVariable("id") long id) {
        Response response;
        try {
            flashcardService.deleteFlashcardSetById(id);
            response = new Response("Flashcard Set deleted.", 200, null);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response = new Response("An error occurred.", 500, null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
