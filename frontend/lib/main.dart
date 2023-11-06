import 'package:capynotes/navigation/app_router.dart';
import 'package:capynotes/view/screens/flashcard_display_screen.dart';
import 'package:capynotes/viewmodel/flashcard_cubit/flashcard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FlashcardCubit(),
        )
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        title: 'CapyNotes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
