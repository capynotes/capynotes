package com.capynotes.noteservice.services;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ListObjectsV2Result;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.util.IOUtils;
import com.capynotes.noteservice.dtos.NoteDto;
import com.capynotes.noteservice.dtos.NoteGrid;
import com.capynotes.noteservice.dtos.VideoTranscribeRequest;
import com.capynotes.noteservice.dtos.VideoTranscribeResponse;
import com.capynotes.noteservice.dtos.*;
import com.capynotes.noteservice.enums.NoteStatus;
import com.capynotes.noteservice.exceptions.FileDownloadException;
import com.capynotes.noteservice.exceptions.FileUploadException;
import com.capynotes.noteservice.models.*;
import com.capynotes.noteservice.repositories.*;

import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.springframework.beans.factory.annotation.Value;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.URL;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class NoteServiceImpl implements NoteService {
    private final NoteRepository noteRepository;
    private final FolderService folderService;
    private final TagRepository tagRepository;
    private final TranscriptRepository transcriptRepository;
    private final SummaryRepository summaryRepository;
    private final TimestampRepository timestampRepository;

    @Value("${aws.bucket.name}")
    private String bucketName;

    private final AmazonS3 amazonS3;

    public NoteServiceImpl(AmazonS3 amazonS3, NoteRepository noteRepository,
                           TranscriptRepository transcriptRepository, SummaryRepository summaryRepository,
                           TimestampRepository timestampRepository, FolderService folderService, TagRepository tagRepository) {
        this.amazonS3 = amazonS3;
        this.noteRepository = noteRepository;
        this.transcriptRepository = transcriptRepository;
        this.summaryRepository = summaryRepository;
        this.timestampRepository = timestampRepository;
        this.folderService = folderService;
        this.tagRepository = tagRepository;
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
        return note;
    }

    @Override
    public Note uploadAudioFromURL(String videoUrl, String fileName, Long userId, Long folderId) {
        //String newName = UUID.randomUUID().toString() + "_" + fileName;
        LocalDateTime uploadTime = LocalDateTime.now();

        /*newAudio = updateAudioTranscription(newAudio.getId(), body.getTranscription());
        newAudio = updateAudioStatus(newAudio.getId(), AudioStatus.DONE);
        newAudio = updateAudioURL(newAudio.getId(), fileUrl.toString());*/

        Note note = new Note(fileName, userId, uploadTime, NoteStatus.TRANSCRIBING);

        if(folderId != 0) {
            if(folderService.addFolderItemToFolder(note, folderId)) {
                noteRepository.save(note);
            } else {
                throw new RuntimeException("Note could not be added to folder");
            }
        } else {
            noteRepository.save(note);
        }

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

    @Override
    public NoteDto findNoteByNoteId(Long noteId) throws FileNotFoundException {
        Optional<Note> note = noteRepository.findNoteById(noteId);
        Optional<Transcript> transcriptOpt = transcriptRepository.getTranscriptByNote_id(noteId);
        Optional<Summary> summary = summaryRepository.getSummaryByNote_id(noteId);
        if(note.isEmpty()) {
            throw new FileNotFoundException("Note with id " + noteId + " does not exist.");
        }
        if(transcriptOpt.isEmpty()) {
            throw new FileNotFoundException("Transcript for Note with id " + noteId + " is not ready.");
        }
        if(summary.isEmpty()) {
            throw new FileNotFoundException("Summary for Note with id " + noteId + " is not ready.");
        }
        Optional<List<Timestamp>> timestamps = timestampRepository.getTimestampsByTranscriptId(transcriptOpt.get().getId());
        if(timestamps.isEmpty()) {
            throw new FileNotFoundException("Timestamps for Note with id " + noteId + " is not ready.");
        }
        Transcript transcript = transcriptOpt.get();
        transcript.setTimestamps(timestamps.get());

        NoteDto noteDto = new NoteDto(note.get(), transcript, summary.get());
        return noteDto;
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
    @Override
    public List<NoteGrid> getNotesInGrid(Long userId) throws FileNotFoundException {
        List<NoteGrid> noteGrids = new ArrayList<>();
        List<Note> notes = findNotesByUserId(userId);
        for (Note note: notes) {
            NoteGrid noteGrid = new NoteGrid(note);
            noteGrids.add(noteGrid);
        }
        return noteGrids;
    }

    @Override
    public void addTag(Tag tag) throws FileNotFoundException {
        Note note = getNote(tag.getNote().getId());
        note.getTags().add(tag);
        noteRepository.save(note);
    }

    @Override
    public void deleteTag(Long id) throws FileNotFoundException {
        tagRepository.deleteById(id);
    }

    @Override
    public boolean addNoteToFolder(Note note, Long folderId) {
        if(folderService.addFolderItemToFolder(note, folderId)) {
            LocalDateTime dateTime = LocalDateTime.now();
            note.setCreationTime(dateTime);
            note.setStatus(NoteStatus.TRANSCRIBING);
            noteRepository.save(note);
            return true;
        }
        return false;
    }

    @Override
    public Note addNote(Note note) {
        LocalDateTime dateTime = LocalDateTime.now();
        note.setCreationTime(dateTime);
        note.setStatus(NoteStatus.TRANSCRIBING);
        return noteRepository.save(note);
    }
  
    @Override
    public void createPdf(NoteDto noteDto, String fileName) throws IOException, InterruptedException {
        //String summary = summaryRepository.getSummaryByNote_id(noteId).get().getSummary();
        String summary = noteDto.getSummary().getSummary();
        String title = noteDto.getNote().getTitle();
        String[] keywords;
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);

            PDFont normal = PDType0Font.load(document, new File("/noteservice/resources/SourceSans3-Regular.ttf"));
            PDFont bold = PDType0Font.load(document, new File("/noteservice/resources/SourceSans3-Bold.ttf"));
            PDFont italic = PDType0Font.load(document, new File("/noteservice/resources/SourceSans3-Italic.ttf"));

            float margin = 50;
            float leading = -20;
            float currentY = page.getMediaBox().getHeight() - margin;
            PDPageContentStream contentStream = new PDPageContentStream(document, page);
            try {
                float middleX = page.getMediaBox().getWidth() / 2;

                contentStream.beginText();
                contentStream.setFont(bold, 12);
                float strWidth = calculateStringWidth(title, bold, 12);
                contentStream.newLineAtOffset(middleX - strWidth/2, currentY);
                contentStream.showText(title);
                contentStream.newLine();
                contentStream.endText();
                currentY += leading;

                float width = page.getMediaBox().getWidth() - 2 * margin;
                float rowX = margin;

                String[] paragraphs = summary.split("\\r?\\n");
                for (String paragraph: paragraphs) {
                    PDFont font = normal;
                    float fontSize = 12;

                    if(paragraph.contains("**")) {
                        font = bold;
                        fontSize = 12;
                        paragraph = paragraph.substring(2, paragraph.length() - 2);
                    } else if(paragraph.contains("*")) {
                        font = normal;
                        fontSize = 12;
                        if(paragraph.lastIndexOf('*') == 0) {
                            paragraph = paragraph.substring(1);
                            paragraph = "• " + paragraph;
                        } else {
                            paragraph = paragraph.substring(2, paragraph.lastIndexOf('*'));
                            font = italic;
                        }
                    } else if(paragraph.contains("#")) {
                        font = bold;
                        fontSize = 16 - paragraph.lastIndexOf("#");
                        System.out.println(paragraph.lastIndexOf("#"));
                        paragraph = paragraph.substring(paragraph.lastIndexOf("#") + 2);
                    }

                    String[] words = paragraph.split("\\s+");
                    StringBuilder line = new StringBuilder();

                    float totalWidth = 0;
                    for (String word : words) {
                        //float wordWidth = PDType1Font.HELVETICA.getStringWidth(word) / 1000 * 12;
                        float wordWidth = calculateStringWidth(word, font, fontSize);
                        totalWidth += wordWidth;
                        if (1.5*rowX + totalWidth > width) {
                            // next line gec
                            if(currentY <= 50) {
                                PDPage newPage = new PDPage();
                                document.addPage(newPage);
                                contentStream.close();
                                contentStream = new PDPageContentStream(document, newPage);
                                currentY = newPage.getMediaBox().getHeight() - 50;
                            } else {
                                currentY += leading;
                            }

                            contentStream.beginText();
                            contentStream.setFont(font, fontSize);
                            contentStream.newLineAtOffset(rowX, currentY);
                            contentStream.showText(line.toString());
                            contentStream.endText();
                            line = new StringBuilder();

                            totalWidth = 0;
                        }

                        line.append(word).append(" ");
                    }
                    currentY += leading;
                    if(fontSize > 12 && fontSize < 16) {
                        currentY += leading / 3;
                    }
                    // add last line
                    contentStream.beginText();
                    contentStream.setFont(font, fontSize);
                    contentStream.newLineAtOffset(rowX, currentY);
                    contentStream.showText(line.toString());
                    contentStream.endText();
                }
                currentY += leading;

                //keyword
                FlashcardSet set = noteDto.getNote().getCardSets().get(0);
                for(Flashcard flashcard: set.getCards()) {
                    //String keyword = flashcard.getFront() + ": " + flashcard.getBack();
                    //String[] frontWords = flashcard.getFront().split("\\s+");
                    String front = flashcard.getFront();
                    String[] backWords = flashcard.getBack().split("\\s+");
                    //String[] words = keyword.split("\\s+");

                    StringBuilder back = new StringBuilder();

                    float totalWidth = 0;

                    //keyword yaz
                    float frontKeywordWidth = calculateStringWidth(front, bold, 12);

                    if (currentY <= 50) {
                        PDPage newPage = new PDPage();
                        document.addPage(newPage);
                        contentStream.close();
                        contentStream = new PDPageContentStream(document, newPage);
                        //contentStream.beginText();
                        currentY = newPage.getMediaBox().getHeight() - 50;
                    }

                    contentStream.beginText();
                    contentStream.setFont(bold, 12);
                    contentStream.newLineAtOffset(rowX, currentY);
                    contentStream.showText(front + ": ");
                    //contentStream.endText();
                    //totalWidth += frontKeywordWidth;
                    float colonWidth = calculateStringWidth(": ", bold, 12);
                    totalWidth += frontKeywordWidth + colonWidth;
                    float keywordOffsetX = totalWidth;

                    //definition yaz
                    //back.append(": ");
                    boolean oneLine = true;
                    for (int j = 0; j < backWords.length; j++) {
                        float wordWidth = calculateStringWidth(backWords[j], bold, 12);
                        totalWidth += wordWidth;

                        if (rowX + totalWidth > width) {

                            if(oneLine) {
                                contentStream.setFont(normal, 12);
                                contentStream.newLineAtOffset(keywordOffsetX, 0);
                                contentStream.showText(back.toString());
                                contentStream.endText();
                            } else {
                                contentStream.setFont(normal, 12);
                                contentStream.newLineAtOffset(rowX, currentY);
                                contentStream.showText(back.toString());
                                contentStream.endText();
                            }

                            currentY += leading;
                            oneLine = false;

                            back = new StringBuilder();

                            totalWidth = 0;
                            contentStream.beginText();
                        }

                        back.append(backWords[j]).append(" ");

                        if (j == backWords.length - 1) {
                            if(oneLine) {
                                contentStream.setFont(normal, 12);
                                contentStream.newLineAtOffset(keywordOffsetX, 0);
                                contentStream.showText(back.toString());
                                contentStream.endText();
                            } else {
                                contentStream.setFont(normal, 12);
                                contentStream.newLineAtOffset(rowX, currentY);
                                contentStream.showText(back.toString());
                                contentStream.endText();
                            }
                        }
                    }

                    currentY += leading;
                    if (currentY <= 50) {
                        PDPage newPage = new PDPage();
                        document.addPage(newPage);
                        contentStream.close();
                        contentStream = new PDPageContentStream(document, newPage);
                        //contentStream.beginText();
                        currentY = newPage.getMediaBox().getHeight() - 50;
                    }
                }
                currentY += 2*leading;

                // tree
                /*if(currentY <= 200) {
                    PDPage newPage = new PDPage();
                    document.addPage(newPage);
                    contentStream.close();
                    contentStream = new PDPageContentStream(document, newPage);
                    currentY = newPage.getMediaBox().getHeight() - 50;
                }*/

                List<Object[]> diagramsOfNote = noteRepository.findDiagramsByNoteId(noteDto.getNote().getId());
                int diagramCounter = 1;
                for(Object[] diagram: diagramsOfNote) {
                    byte[] diagramByte = downloadFromS3("public/" + (String) diagram[3]);
                    PDImageXObject pdImage = PDImageXObject.createFromByteArray(document, diagramByte, null);

                    if(currentY <= pdImage.getHeight()) {
                        PDPage newPage = new PDPage();
                        document.addPage(newPage);
                        contentStream.close();
                        contentStream = new PDPageContentStream(document, newPage);
                        currentY = newPage.getMediaBox().getHeight() - 50;
                    }

                    contentStream.beginText();
                    contentStream.setFont(bold, 12);
                    contentStream.newLineAtOffset(rowX, currentY);
                    contentStream.showText("Diagram " + diagramCounter);
                    diagramCounter++;
                    contentStream.endText();
                    currentY += leading;

                    float divisor = 1f;
                    while(pdImage.getWidth()*divisor >= document.getPage(0).getMediaBox().getWidth()
                            || pdImage.getHeight()*divisor >= document.getPage(0).getMediaBox().getWidth()) {
                        divisor = 0.9f * divisor;
                    }
                    float startX = middleX - pdImage.getWidth()*divisor / 2;
                    contentStream.drawImage(pdImage, startX, currentY - pdImage.getHeight()*divisor, pdImage.getWidth()*divisor, pdImage.getHeight()*divisor);

                    currentY = currentY - pdImage.getHeight()*divisor - 50;
                    /*float startX = middleX - pdImage.getWidth() / 2;
                    contentStream.drawImage(pdImage, startX, currentY - pdImage.getHeight(), pdImage.getWidth(), pdImage.getHeight());

                    currentY = currentY - pdImage.getHeight() - 50;

                    if(currentY <= 200) {
                        PDPage newPage = new PDPage();
                        document.addPage(newPage);
                        contentStream.close();
                        contentStream = new PDPageContentStream(document, newPage);
                        currentY = newPage.getMediaBox().getHeight() - 50;
                    }*/
                }


            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                contentStream.close();
            }

            document.save(fileName + ".pdf");
        }
    }

    @Override
    public byte[] downloadFromS3(String key) throws IOException {
        S3Object s3Object = amazonS3.getObject(bucketName, key);
        InputStream inputStream = s3Object.getObjectContent();

        return org.apache.commons.io.IOUtils.toByteArray(inputStream);
    }

    @Override
    public List<NoteGrid> getNotesWithSameTag(CrossReference crossReference) throws FileNotFoundException {
        List<NoteGrid> noteGridsOfUser = new ArrayList<>();
        for(Note note: findNotesByUserId(crossReference.getUserId())) {
            noteGridsOfUser.add(new NoteGrid(note));
        }
        List<NoteGrid> result = new ArrayList<>();
        for(NoteGrid noteGrid: noteGridsOfUser) {
            if(!Objects.equals(noteGrid.getId(), crossReference.getCurrentNoteId())) {
                for(String filter: noteGrid.getSearchFilters()) {
                    if(filter.equals(crossReference.getTag())) {
                        result.add(noteGrid);
                    }
                }
            }
        }
        return result;
    }
    private Note getNote(Long id) throws FileNotFoundException {
        Optional<Note> note = noteRepository.findNoteById(id);
        if(note.isEmpty()) {
            throw new FileNotFoundException("Note with id " + id + " does not exist.");
        }
        return note.get();
    }

    public static float calculateStringWidth(String text, PDFont font, float fontSize) throws IOException {
        return font.getStringWidth(text) / 1000 * fontSize;
    }
    @Override
    public void uploadToS3(File file) throws IOException {
        ObjectMetadata metadata = new ObjectMetadata();
        byte[] bytes = IOUtils.toByteArray(new FileInputStream(file));
        metadata.setContentLength(bytes.length);
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(bytes);
        String key = "public/pdfs/" + file.getName();
        amazonS3.putObject(bucketName, key, byteArrayInputStream, metadata);
    }

    @Override
    public void updateNote(Long noteId, NoteStatus noteStatus, String pdfKey) {
        Optional<Note> noteOpt = noteRepository.findNoteById(noteId);
        if(noteOpt.isPresent()) {
            Note note = noteOpt.get();
            note.setStatus(noteStatus);
            note.setPdfKey(pdfKey);
            noteRepository.save(note);
        }
    }
    // should listen rabbit mq for creation of keywords
}
