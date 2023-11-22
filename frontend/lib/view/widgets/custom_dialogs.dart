import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class CustomDialogs {
  static void showConfirmDialog(BuildContext context, String title,
      String description, Function onConfirm) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: description,
        title: title,
        lottieBuilder: Lottie.asset("assets/lotties/question_lottie.json",
            fit: BoxFit.contain),
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: "No",
            iconData: Icons.close,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: onConfirm,
            text: "Yes",
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
