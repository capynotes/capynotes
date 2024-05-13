import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../translations/locale_keys.g.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    required this.label,
    this.initialValue,
    this.hint,
    this.isObscure,
    this.maxLines,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.customValidator,
    this.enabled,
    super.key,
  });

  final String? Function(String?)? customValidator;
  bool? enabled = true;
  String? initialValue;
  String label;
  String? hint;
  int? maxLines;
  bool? isObscure;
  Widget? suffixIcon;
  Widget? prefixIcon;
  TextEditingController? controller;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(color: Colors.white),
        // ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines ?? 1,
          obscureText: isObscure ?? false,
          onChanged: onChanged,
          validator: customValidator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.validators_required.tr(args: [label]);
                }
                return null;
              },
          enabled: enabled,
          initialValue: initialValue,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }
}
