import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });
  Widget child;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: [ColorConstants.primaryColor, ColorConstants.lightBlue])),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          onPressed: onPressed,
          child: child),
    );
  }
}
