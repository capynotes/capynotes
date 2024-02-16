import 'package:capynotes/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class NotePDFScreen extends StatelessWidget {
  const NotePDFScreen({Key? key, required this.url, required this.noteName})
      : super(key: key);

  final String url;
  final String noteName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noteName),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
