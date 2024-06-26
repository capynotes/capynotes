import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/navigation/app_router.dart';
import 'package:capynotes/services/auth_service.dart';
import 'package:capynotes/services/flashcard_service.dart';
import 'package:capynotes/services/folder_service.dart';
import 'package:capynotes/services/note_generation_service.dart';
import 'package:capynotes/viewmodel/audio_cubit/audio_cubit.dart';
import 'package:capynotes/viewmodel/auth/login/login_cubit.dart';
import 'package:capynotes/viewmodel/auth/password/change_password/change_password_cubit.dart';
import 'package:capynotes/viewmodel/auth/password/forgot_password/forgot_password_cubit.dart';
import 'package:capynotes/viewmodel/auth/register/register_cubit.dart';
import 'package:capynotes/viewmodel/flashcard_cubit/flashcard_cubit.dart';
import 'package:capynotes/viewmodel/home_cubit/home_cubit.dart';
import 'package:capynotes/viewmodel/note_generation_cubit/note_generation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'amplifyconfiguration.dart';
import 'constants/asset_paths.dart';
import 'services/audio_service.dart';
import 'services/note_service.dart';
import 'viewmodel/folder_cubit/folder_cubit.dart';
import 'viewmodel/note_cubit/note_cubit.dart';

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, storage]);

    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await _configureAmplify();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path: AssetPaths.translations,
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        child: MyApp(prefs: prefs)),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({required this.prefs, super.key});
  final SharedPreferences prefs;
  static final AuthService authService = AuthService();
  static final NoteGenerationService noteGenerationService =
      NoteGenerationService();
  static final AudioService audioService = AudioService();
  static final NoteService noteService = NoteService();
  static final FlashcardService flashcardService = FlashcardService();
  static final FolderService folderService = FolderService();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(widget.prefs.getBool("isFirstTime") ?? true);
    widget.prefs.setBool("isFirstTime", false);
  }

  late AppRouter _appRouter;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(MyApp.authService),
        ),
        BlocProvider(create: (context) => RegisterCubit(MyApp.authService)),
        BlocProvider(
            create: (context) => ChangePasswordCubit(MyApp.authService)),
        BlocProvider(
            create: (context) => ForgotPasswordCubit(MyApp.authService)),
        BlocProvider(
          create: (context) => FlashcardCubit(MyApp.flashcardService),
        ),
        BlocProvider(
          create: (context) => NoteGenerationCubit(MyApp.noteGenerationService),
        ),
        BlocProvider(
          create: (context) => AudioCubit(MyApp.audioService),
        ),
        BlocProvider(
          create: (context) => NoteCubit(MyApp.noteService),
        ),
        BlocProvider(
          create: (context) => FolderCubit(MyApp.folderService),
        ),
        BlocProvider(
          create: (context) => HomeCubit(MyApp.folderService),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        title: 'CapyNotes',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ColorConstants.primaryColor),
          // scaffoldBackgroundColor: ColorConstants.background,
        ),
      ),
    );
  }
}
