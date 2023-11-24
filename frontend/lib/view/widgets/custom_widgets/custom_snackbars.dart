import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class CustomSnackbars {
  static void displaySuccessMotionToast(BuildContext context, String title,
      String description, Function? onClose) {
    MotionToast toast = MotionToast.success(
      onClose: onClose,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(description),
      barrierColor: Colors.black.withOpacity(0.3),
      dismissable: false,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
    );
    toast.show(context);
  }

  static void displayWarningMotionToast(BuildContext context, String title,
      String description, Function? onClose) {
    MotionToast.warning(
      onClose: onClose,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(description),
      barrierColor: Colors.black.withOpacity(0.3),
      dismissable: false,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
    ).show(context);
  }

  static void displayErrorMotionToast(BuildContext context, String title,
      String description, Function? onClose) {
    MotionToast.error(
      onClose: onClose,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(description),
      barrierColor: Colors.black.withOpacity(0.3),
      dismissable: false,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
    ).show(context);
  }

  static void displayInfoMotionToast(BuildContext context, String title,
      String description, Function? onClose) {
    MotionToast.info(
      onClose: onClose,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(description),
      barrierColor: Colors.black.withOpacity(0.3),
      dismissable: false,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
    ).show(context);
  }
}
