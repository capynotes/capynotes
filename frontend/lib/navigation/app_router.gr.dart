// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    FlashcardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FlashcardScreen(),
      );
    }
  };
}

/// generated route for
/// [FlashcardScreen]
class FlashcardRoute extends PageRouteInfo<void> {
  const FlashcardRoute({List<PageRouteInfo>? children})
      : super(
          FlashcardRoute.name,
          initialChildren: children,
        );

  static const String name = 'FlashcardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
