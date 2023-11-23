import 'package:capynotes/navigation/app_router.dart';
import 'package:capynotes/services/auth_service.dart';
import 'package:capynotes/viewmodel/auth/login/login_cubit.dart';
import 'package:capynotes/viewmodel/auth/password/change_password/change_password_cubit.dart';
import 'package:capynotes/viewmodel/auth/password/forgot_password/forgot_password_cubit.dart';
import 'package:capynotes/viewmodel/auth/register/register_cubit.dart';
import 'package:capynotes/viewmodel/flashcard_cubit/flashcard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final _appRouter = AppRouter();
  static final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(authService),
        ),
        BlocProvider(create: (context) => RegisterCubit(authService)),
        BlocProvider(create: (context) => ChangePasswordCubit(authService)),
        BlocProvider(create: (context) => ForgotPasswordCubit(authService)),
        BlocProvider(
          create: (context) => FlashcardCubit(),
        )
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        title: 'CapyNotes',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primarySwatch: Colors.deepPurple,
        ),
      ),
    );
  }
}
