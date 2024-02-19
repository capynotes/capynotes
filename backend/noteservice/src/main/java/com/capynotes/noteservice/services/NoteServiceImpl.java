package com.capynotes.noteservice.services;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ListObjectsV2Result;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.exceptions.FileDownloadException;
import com.capynotes.noteservice.exceptions.FileUploadException;
import com.capynotes.noteservice.models.Note;
import com.capynotes.noteservice.repositories.NoteRepository;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class NoteServiceImpl implements NoteService {
    private final NoteRepository noteRepository;
    
    @Value("${aws.bucket.name}")
    private String bucketName;

    private final AmazonS3 amazonS3;

    public NoteServiceImpl(AmazonS3 amazonS3, NoteRepository noteRepository) {
        this.amazonS3 = amazonS3;
        this.noteRepository = noteRepository;
    }

    @Override
    public Note uploadAudio(MultipartFile multipartFile, Long userId, String fileName) throws IOException, FileUploadException {
        //String fileName = UUID.randomUUID().toString() + "_" + multipartFile.getOriginalFilename();
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(multipartFile.getSize());
        try {
            amazonS3.putObject(new PutObjectRequest(bucketName, fileName, multipartFile.getInputStream(), metadata));
        } catch (Exception e) {
            throw new FileUploadException("Could not upload the file!" + e.toString());
        }

        String url = amazonS3.getUrl(bucketName, fileName).toString();
        LocalDateTime dateTime = LocalDateTime.now();
        Note note = new Note(fileName, userId, url, dateTime, NoteStatus.TRANSCRIBING);
        note = noteRepository.save(note);
        Long note_id = note.getId();
        // This method needs to send note_id, which is just created, over a rabbit mq queue
        return note;
    }

    /*@Override
    public Object downloadAudio(String fileName) throws IOException, FileDownloadException {
        if (bucketIsEmpty()) {
            throw new FileDownloadException("Requested bucket does not exist or is empty");
        }
        S3Object object = amazonS3.getObject(bucketName, fileName);
        try (S3ObjectInputStream s3is = object.getObjectContent()) {
            try (FileOutputStream fileOutputStream = new FileOutputStream(fileName)) {
                byte[] read_buf = new byte[1024];
                int read_len = 0;
                while ((read_len = s3is.read(read_buf)) > 0) {
                    fileOutputStream.write(read_buf, 0, read_len);
                }
            }
            Path pathObject = Paths.get(fileName);
            Resource resource = new UrlResource(pathObject.toUri());

            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new FileDownloadException("Could not find the file!");
            }
        }
    }*/
    @Override
    public List<Note> findNotesByUserId(Long userId) throws FileNotFoundException {
        Optional<List<Note>> notes = noteRepository.findNoteByUserId(userId);
        if(notes.isEmpty()) {
            throw new FileNotFoundException("User with id " + userId + " does not have any notes created.");
        }
        return notes.get();
    }

    // For download audio function
    private boolean bucketIsEmpty() {
        ListObjectsV2Result result = amazonS3.listObjectsV2(this.bucketName);
        if (result == null){
            return false;
        }
        List<S3ObjectSummary> objects = result.getObjectSummaries();
        return objects.isEmpty();
    }

    @Override
    public void deleteNote(Long id){
        noteRepository.deleteById(id);
    }

    // should listen rabbit mq for creation of keywords
}
