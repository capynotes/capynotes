import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

// ignore: must_be_immutable
class DrawerComponent extends StatelessWidget {
  DrawerComponent({
    required this.title,
    required this.onTap,
    required this.prefixIcon,
    super.key,
  });
  String title;
  void Function()? onTap;
  Widget prefixIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: const Border.symmetric(
                horizontal: BorderSide(color: Colors.black, width: 0.5)),
            color: ColorConstants.lightBlue),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            prefixIcon,
            const SizedBox(
              width: 20,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
