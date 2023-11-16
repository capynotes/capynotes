import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/screens/flashcard_display_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: FlashcardRoute.page, initial: true),
      ];
}
