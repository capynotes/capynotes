import 'package:flutter/foundation.dart';

class AssetPaths {
  // Images
  static String micImage =
      kIsWeb ? "images/mic_image.png" : "assets/images/mic_image.png";
  static String folderImage =
      kIsWeb ? "images/folder_image.png" : "assets/images/folder_image.png";
  static String notebookImage =
      kIsWeb ? "images/notebook_image.jpg" : "assets/images/notebook_image.jpg";
  // Icons
  static String capyNotesNoBg = kIsWeb
      ? "icons/capynotes_logo_no_bg.png"
      : "assets/icons/capynotes_logo_no_bg.png";

  // Lotties
  static String questionLottie = kIsWeb
      ? "lotties/question_lottie.json"
      : "assets/lotties/question_lottie.json";
  static String successLottie = kIsWeb
      ? "lotties/success_lottie.json"
      : "assets/lotties/success_lottie.json";
  static String loadingLottie = kIsWeb
      ? "lotties/loading_lottie.json"
      : "assets/lotties/loading_lottie.json";
  static String youtubeLottie = kIsWeb
      ? "lotties/youtube_lottie.json"
      : "assets/lotties/youtube_lottie.json";
  static String microphoneLottie = kIsWeb
      ? "lotties/microphone_lottie.json"
      : "assets/lotties/microphone_lottie.json";
  static String browseFolderLottie = kIsWeb
      ? "lotties/browse_folder_lottie.json"
      : "assets/lotties/browse_folder_lottie.json";
  // Translations
  static String translations = kIsWeb ? "translations" : "assets/translations";
}
