import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String dateToString(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static String durationToString(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);

    return "$minutes min $seconds sec";
  }
}
