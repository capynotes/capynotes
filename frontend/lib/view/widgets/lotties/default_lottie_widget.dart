import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultLottie extends StatelessWidget {
  const DefaultLottie({super.key, required this.path, this.height, this.width});
  final String path;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(path, height: height, width: width),
    );
  }
}
