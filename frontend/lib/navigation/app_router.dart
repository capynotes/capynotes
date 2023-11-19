import 'package:auto_route/auto_route.dart';

import '../view/screens/auth/change_password_screen.dart';
import '../view/screens/auth/forgot_password_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/register_screen.dart';
import '../view/screens/flashcard/add_flashcard_screen.dart';
import '../view/screens/flashcard/flashcard_display_screen.dart';
import '../view/screens/profile_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, path: "/login"),
        AutoRoute(page: RegisterRoute.page, path: "/register"),
        AutoRoute(page: ChangePasswordRoute.page, path: "/change-password"),
        AutoRoute(page: ForgotPasswordRoute.page, path: "/forgot-password"),
        AutoRoute(page: ProfileRoute.page, path: "/profile"),
        AutoRoute(
            page: FlashcardRoute.page, initial: true, path: "/flashcards"),
        AutoRoute(page: AddFlashcardRoute.page, path: "/add-flashcard"),
      ];

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (true ||
        resolver.route.name == LoginRoute.name ||
        resolver.route.name == RegisterRoute.name ||
        resolver.route.name == ForgotPasswordRoute.name) {
      resolver.next();
    } else {
      resolver.redirect(const LoginRoute());
    }
  }
}
