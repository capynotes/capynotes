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
}
