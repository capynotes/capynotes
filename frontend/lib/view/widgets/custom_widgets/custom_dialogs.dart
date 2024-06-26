import 'package:capynotes/constants/asset_paths.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../../../translations/locale_keys.g.dart';
import 'custom_text_form_field.dart';

class CustomDialogs {
  static void showConfirmDialog(BuildContext context, String title,
      String description, Function onConfirm) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: description,
        title: title,
        lottieBuilder:
            Lottie.asset(AssetPaths.questionLottie, fit: BoxFit.contain),
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: LocaleKeys.buttons_no.tr(),
            iconData: Icons.close,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: onConfirm,
            text: LocaleKeys.buttons_yes.tr(),
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  static void showSuccessDialog(BuildContext context, String title,
      String description, String? okTxt, Function onOk) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: description,
        title: title,
        barrierDismissible: false,
        lottieBuilder:
            Lottie.asset(AssetPaths.successLottie, fit: BoxFit.contain),
        context: context,
        actions: [
          IconsButton(
            onPressed: onOk,
            text: okTxt ?? LocaleKeys.buttons_yes.tr(),
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  static void showSinglePropFormDialog(
      {required BuildContext context,
      required GlobalKey<FormState> formKey,
      required String title,
      required String label,
      required TextEditingController controller,
      required Function() onConfirm}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Form(
              key: formKey,
              child: CustomTextFormField(
                controller: controller,
                label: label,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onConfirm();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        });
  }
}
