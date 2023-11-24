import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/screens/note_generation_screen.dart';
import '../view/screens/auth/change_password_screen.dart';
import '../view/screens/auth/forgot_password_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/register_screen.dart';
import '../view/screens/flashcard/add_flashcard_screen.dart';
import '../view/screens/flashcard/flashcard_display_screen.dart';
import '../view/screens/onboarding_screen.dart';
import '../view/screens/profile_screen.dart';

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
        AutoRoute(page: FlashcardRoute.page, path: "/flashcards"),
        AutoRoute(page: AddFlashcardRoute.page, path: "/add-flashcard"),
        AutoRoute(
          page: OnBoardingRoute.page,
          path: "/onboarding",
          initial: true,
          guards: [
            AutoRouteGuard.simple((resolver, _) {
              if (isFirstTime) {
                resolver.next();
              } else {
                pushNamed("/note-generation");
              }
            })
          ],
        ),
        AutoRoute(page: NoteGenerationRoute.page, path: "/note-generation"),
      ];

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (resolver.route.name == LoginRoute.name ||
        resolver.route.name == RegisterRoute.name ||
        resolver.route.name == ForgotPasswordRoute.name) {
      resolver.next();
    } else {
      if (false) {
        resolver.redirect(const LoginRoute());
      } else {
        resolver.next();
      }
    }
  }
}
