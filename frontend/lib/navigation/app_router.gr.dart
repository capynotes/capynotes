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
    AboutUsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutUsScreen(),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChangePasswordScreen(),
      );
    },
    ContactUsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ContactUsScreen(),
      );
    },
    EditFlashcardSetRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EditFlashcardSetRouteArgs>(
          orElse: () =>
              EditFlashcardSetRouteArgs(setID: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditFlashcardSetScreen(
          key: args.key,
          setID: args.setID,
        ),
      );
    },
    FlashcardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<FlashcardRouteArgs>(
          orElse: () => FlashcardRouteArgs(setID: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FlashcardScreen(
          key: args.key,
          setID: args.setID,
        ),
      );
    },
    FolderRoute.name: (routeData) {
      final args = routeData.argsAs<FolderRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FolderScreen(
          key: args.key,
          folderID: args.folderID,
          title: args.title,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    MyAudiosRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyAudiosScreen(),
      );
    },
    MyNotesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyNotesScreen(),
      );
    },
    NoteGenerationDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NoteGenerationDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteGenerationDetailsScreen(
          key: args.key,
          source: args.source,
          folderID: args.folderID,
        ),
      );
    },
    NoteGenerationRoute.name: (routeData) {
      final args = routeData.argsAs<NoteGenerationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteGenerationScreen(
          key: args.key,
          folderID: args.folderID,
        ),
      );
    },
    NoteRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NoteRouteArgs>(
          orElse: () => NoteRouteArgs(noteID: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteScreen(
          key: args.key,
          noteID: args.noteID,
        ),
      );
    },
    OnBoardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnBoardingScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterScreen(),
      );
    },
  };
}

/// generated route for
/// [AboutUsScreen]
class AboutUsRoute extends PageRouteInfo<void> {
  const AboutUsRoute({List<PageRouteInfo>? children})
      : super(
          AboutUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ContactUsScreen]
class ContactUsRoute extends PageRouteInfo<void> {
  const ContactUsRoute({List<PageRouteInfo>? children})
      : super(
          ContactUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactUsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditFlashcardSetScreen]
class EditFlashcardSetRoute extends PageRouteInfo<EditFlashcardSetRouteArgs> {
  EditFlashcardSetRoute({
    Key? key,
    required int setID,
    List<PageRouteInfo>? children,
  }) : super(
          EditFlashcardSetRoute.name,
          args: EditFlashcardSetRouteArgs(
            key: key,
            setID: setID,
          ),
          rawPathParams: {'id': setID},
          initialChildren: children,
        );

  static const String name = 'EditFlashcardSetRoute';

  static const PageInfo<EditFlashcardSetRouteArgs> page =
      PageInfo<EditFlashcardSetRouteArgs>(name);
}

class EditFlashcardSetRouteArgs {
  const EditFlashcardSetRouteArgs({
    this.key,
    required this.setID,
  });

  final Key? key;

  final int setID;

  @override
  String toString() {
    return 'EditFlashcardSetRouteArgs{key: $key, setID: $setID}';
  }
}

/// generated route for
/// [FlashcardScreen]
class FlashcardRoute extends PageRouteInfo<FlashcardRouteArgs> {
  FlashcardRoute({
    Key? key,
    required int setID,
    List<PageRouteInfo>? children,
  }) : super(
          FlashcardRoute.name,
          args: FlashcardRouteArgs(
            key: key,
            setID: setID,
          ),
          rawPathParams: {'id': setID},
          initialChildren: children,
        );

  static const String name = 'FlashcardRoute';

  static const PageInfo<FlashcardRouteArgs> page =
      PageInfo<FlashcardRouteArgs>(name);
}

class FlashcardRouteArgs {
  const FlashcardRouteArgs({
    this.key,
    required this.setID,
  });

  final Key? key;

  final int setID;

  @override
  String toString() {
    return 'FlashcardRouteArgs{key: $key, setID: $setID}';
  }
}

/// generated route for
/// [FolderScreen]
class FolderRoute extends PageRouteInfo<FolderRouteArgs> {
  FolderRoute({
    Key? key,
    required int folderID,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
          FolderRoute.name,
          args: FolderRouteArgs(
            key: key,
            folderID: folderID,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'FolderRoute';

  static const PageInfo<FolderRouteArgs> page = PageInfo<FolderRouteArgs>(name);
}

class FolderRouteArgs {
  const FolderRouteArgs({
    this.key,
    required this.folderID,
    required this.title,
  });

  final Key? key;

  final int folderID;

  final String title;

  @override
  String toString() {
    return 'FolderRouteArgs{key: $key, folderID: $folderID, title: $title}';
  }
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyAudiosScreen]
class MyAudiosRoute extends PageRouteInfo<void> {
  const MyAudiosRoute({List<PageRouteInfo>? children})
      : super(
          MyAudiosRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyAudiosRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyNotesScreen]
class MyNotesRoute extends PageRouteInfo<void> {
  const MyNotesRoute({List<PageRouteInfo>? children})
      : super(
          MyNotesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyNotesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NoteGenerationDetailsScreen]
class NoteGenerationDetailsRoute
    extends PageRouteInfo<NoteGenerationDetailsRouteArgs> {
  NoteGenerationDetailsRoute({
    Key? key,
    required String source,
    required int folderID,
    List<PageRouteInfo>? children,
  }) : super(
          NoteGenerationDetailsRoute.name,
          args: NoteGenerationDetailsRouteArgs(
            key: key,
            source: source,
            folderID: folderID,
          ),
          rawPathParams: {'src': source},
          initialChildren: children,
        );

  static const String name = 'NoteGenerationDetailsRoute';

  static const PageInfo<NoteGenerationDetailsRouteArgs> page =
      PageInfo<NoteGenerationDetailsRouteArgs>(name);
}

class NoteGenerationDetailsRouteArgs {
  const NoteGenerationDetailsRouteArgs({
    this.key,
    required this.source,
    required this.folderID,
  });

  final Key? key;

  final String source;

  final int folderID;

  @override
  String toString() {
    return 'NoteGenerationDetailsRouteArgs{key: $key, source: $source, folderID: $folderID}';
  }
}

/// generated route for
/// [NoteGenerationScreen]
class NoteGenerationRoute extends PageRouteInfo<NoteGenerationRouteArgs> {
  NoteGenerationRoute({
    Key? key,
    required int folderID,
    List<PageRouteInfo>? children,
  }) : super(
          NoteGenerationRoute.name,
          args: NoteGenerationRouteArgs(
            key: key,
            folderID: folderID,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteGenerationRoute';

  static const PageInfo<NoteGenerationRouteArgs> page =
      PageInfo<NoteGenerationRouteArgs>(name);
}

class NoteGenerationRouteArgs {
  const NoteGenerationRouteArgs({
    this.key,
    required this.folderID,
  });

  final Key? key;

  final int folderID;

  @override
  String toString() {
    return 'NoteGenerationRouteArgs{key: $key, folderID: $folderID}';
  }
}

/// generated route for
/// [NoteScreen]
class NoteRoute extends PageRouteInfo<NoteRouteArgs> {
  NoteRoute({
    Key? key,
    required int noteID,
    List<PageRouteInfo>? children,
  }) : super(
          NoteRoute.name,
          args: NoteRouteArgs(
            key: key,
            noteID: noteID,
          ),
          rawPathParams: {'id': noteID},
          initialChildren: children,
        );

  static const String name = 'NoteRoute';

  static const PageInfo<NoteRouteArgs> page = PageInfo<NoteRouteArgs>(name);
}

class NoteRouteArgs {
  const NoteRouteArgs({
    this.key,
    required this.noteID,
  });

  final Key? key;

  final int noteID;

  @override
  String toString() {
    return 'NoteRouteArgs{key: $key, noteID: $noteID}';
  }
}

/// generated route for
/// [OnBoardingScreen]
class OnBoardingRoute extends PageRouteInfo<void> {
  const OnBoardingRoute({List<PageRouteInfo>? children})
      : super(
          OnBoardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnBoardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
