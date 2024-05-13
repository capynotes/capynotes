import 'package:auto_route/auto_route.dart';
import 'package:capynotes/model/user/user_info_model.dart';
import 'package:capynotes/view/screens/my_audios_screen.dart';
import 'package:capynotes/view/screens/note/note_generation_screen.dart';
import 'package:flutter/material.dart';
import '../view/screens/about_us_screen.dart';
import '../view/screens/auth/change_password_screen.dart';
import '../view/screens/auth/forgot_password_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/register_screen.dart';
import '../view/screens/contact_us_screen.dart';
import '../view/screens/flashcard/edit_flashcard_set_screen.dart';
import '../view/screens/flashcard/flashcard_display_screen.dart';
import '../view/screens/home_screen.dart';
import '../view/screens/note/my_notes_screen.dart';
import '../view/screens/note/note_generation_details_screen.dart';
import '../view/screens/note/note_screen.dart';
import '../view/screens/onboarding_screen.dart';
import '../view/screens/profile_screen.dart';
import '../view/screens/folder_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  bool isFirstTime;
  AppRouter(this.isFirstTime);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, path: "/login"),
        AutoRoute(page: RegisterRoute.page, path: "/register"),
        AutoRoute(page: ChangePasswordRoute.page, path: "/change-password"),
        AutoRoute(page: ForgotPasswordRoute.page, path: "/forgot-password"),
        AutoRoute(page: ProfileRoute.page, path: "/profile"),
        AutoRoute(page: FlashcardRoute.page, path: "/flashcard/:id"),
        AutoRoute(
            page: EditFlashcardSetRoute.page, path: "/edit-flashcard/:id"),
        AutoRoute(page: MyNotesRoute.page, path: "/my-notes"),
        AutoRoute(page: NoteRoute.page, path: "/note/:id"),
        AutoRoute(
            page: NoteGenerationDetailsRoute.page,
            path: "/note-generation-details/:src"),
        AutoRoute(
          page: OnBoardingRoute.page,
          path: "/onboarding",
          initial: true,
          guards: [
            AutoRouteGuard.simple((resolver, _) {
              if (isFirstTime) {
                resolver.next();
              } else {
                navigateNamed("/home");
              }
            })
          ],
        ),
        AutoRoute(page: NoteGenerationRoute.page, path: "/note-generation"),
        AutoRoute(page: AboutUsRoute.page, path: "/about-us"),
        AutoRoute(page: ContactUsRoute.page, path: "/contact-us"),
        AutoRoute(page: MyAudiosRoute.page, path: "/my-audios"),
        AutoRoute(page: HomeRoute.page, path: "/home"),
        AutoRoute(page: FolderRoute.page, path: "/folder"),
      ];

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (resolver.route.name == LoginRoute.name ||
        resolver.route.name == RegisterRoute.name ||
        resolver.route.name == ForgotPasswordRoute.name ||
        resolver.route.name == OnBoardingRoute.name) {
      resolver.next();
    } else {
      if (UserInfo.loggedUser == null) {
        resolver.redirect(const LoginRoute(), replace: true);
      } else {
        resolver.next();
      }
    }
  }
}
