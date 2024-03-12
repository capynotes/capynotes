import 'package:flutter/foundation.dart';

class AssetPaths {
  // Images
  static String micImage =
      kIsWeb ? "images/mic_image.png" : "assets/images/mic_image.png";

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
  static String browseFilesLottie = kIsWeb
      ? "lotties/browse_files_lottie.json"
      : "assets/lotties/browse_files_lottie.json";

  // Translations
  static String translations = kIsWeb ? "translations" : "assets/translations";
}
