import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultLottie extends StatelessWidget {
  const DefaultLottie({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(path),
    );
  }
}
