import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {super.key, required this.child, required this.onPressed, this.disabled});
  Widget child;
  void Function()? onPressed;
  bool? disabled;
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
          onPressed: disabled != null
              ? disabled == true
                  ? null
                  : onPressed
              : onPressed,
          child: child),
    );
  }
}
