import 'package:flutter/material.dart';

class FlashcardFace extends StatelessWidget {
  const FlashcardFace({
    super.key,
    required this.text,
    this.color,
  });
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF006666),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
