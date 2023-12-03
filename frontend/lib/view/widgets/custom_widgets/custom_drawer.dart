import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/asset_paths.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/navigation/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/user/user_info_model.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../viewmodel/auth/login/login_cubit.dart';
import 'drawer_component.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    String nameField =
        "${UserInfo.loggedUser!.name} ${UserInfo.loggedUser!.surname}";
    return Drawer(
      backgroundColor: ColorConstants.primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Expanded(
            child: Image.asset(
              AssetPaths.capyNotesNoBg,
              height: 100,
              width: 100,
            ),
          ),
          Expanded(
            child: Text(nameField,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: DrawerComponent(
              title: LocaleKeys.buttons_my_profile.tr(),
              onTap: () {
                context.router.popAndPush(const ProfileRoute());
              },
              prefixIcon: Icon(
                Icons.person,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: DrawerComponent(
              title: "My Audios",
              onTap: () {
                context.router.popAndPush(const MyAudiosRoute());
              },
              prefixIcon: Icon(
                Icons.audiotrack_outlined,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: DrawerComponent(
              title: LocaleKeys.buttons_about_us.tr(),
              onTap: () {
                context.router.popAndPush(const AboutUsRoute());
              },
              prefixIcon: Icon(
                Icons.info_outlined,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: DrawerComponent(
              title: LocaleKeys.buttons_contact_us.tr(),
              onTap: () {
                context.router.popAndPush(const ContactUsRoute());
              },
              prefixIcon: Icon(
                Icons.contact_support_outlined,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: DrawerComponent(
              title: LocaleKeys.buttons_logout.tr(),
              onTap: () {
                UserInfo.loggedUser = null;
                if (!context.read<LoginCubit>().rememberMe) {
                  context.read<LoginCubit>().emailController.clear();
                  context.read<LoginCubit>().passwordController.clear();
                }

                context.router.replaceNamed("/login");
              },
              prefixIcon: Icon(
                Icons.exit_to_app_outlined,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(LocaleKeys.buttons_terms_of_service.tr())),
                SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.grey[400],
                    thickness: 1,
                    width: 1,
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(LocaleKeys.buttons_privacy_policy.tr())),
              ],
            ),
          ),
          Expanded(
            child: Text(
              "${LocaleKeys.labels_version.tr()} 1.0.0",
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }
}
