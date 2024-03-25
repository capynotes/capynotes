class ApiConstants {
  static String baseUrl = "http://139.179.55.239:8080/";

  // Authentication related endpoints
  static String register = "person/register";
  static String login = "person/login";
  static String changePw = "person/change-password";
  static String forgotPw = "person/forgot-password?email=";

  // Note related endpoints
  static String generateNoteFromFile = "note/upload-audio";
  static String generateNoteFromVideo = "note/from-video";
  static String getMyAudios = "audio/";
  static String getMyNotes = "note/user/";
  static String getNote = "note/";

  // Flashcard related endpoints
  static String getFlashcardSets = "flashcard/set/note/";
  static String createFlashcardSet = "flashcard/add-set";
  static String getFlashcardSet = "flashcard/set/";
  static String addFlashcard = "flashcard/add";
  static String flashcard = "flashcard/";
  static String editFlashcard = "flashcard/edit";
}
