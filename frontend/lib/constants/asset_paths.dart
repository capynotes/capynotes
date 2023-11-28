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

  // Translations
  static String translations = kIsWeb ? "translations" : "assets/translations";
}
