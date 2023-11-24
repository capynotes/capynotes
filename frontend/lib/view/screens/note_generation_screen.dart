import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/viewmodel/note_generation_cubit/note_generation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class NoteGenerationScreen extends StatefulWidget {
  const NoteGenerationScreen({super.key});

  @override
  State<NoteGenerationScreen> createState() => _NoteGenerationScreenState();
}

class _NoteGenerationScreenState extends State<NoteGenerationScreen> {
  bool isGenerateFlashcards = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: const Text("Note Generation"),
        centerTitle: true,
      ),
      body: BlocConsumer<NoteGenerationCubit, NoteGenerationState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  CustomElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/mic_image.png",
                              color: ColorConstants.primaryColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Record Audio"),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {}),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("-OR-",
                      style: TextStyle(
                          fontSize: 24,
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    child: const Text("Browse Files to Import Audio"),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: CheckboxListTile(
                      tileColor: ColorConstants.primaryColor,
                      side: BorderSide(color: ColorConstants.lightBlue),
                      activeColor: ColorConstants.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      checkColor: ColorConstants.primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: context
                          .read<NoteGenerationCubit>()
                          .isGenerateFlashcards,
                      onChanged: (value) {
                        context
                            .read<NoteGenerationCubit>()
                            .changeGenerateFlashcards(value ?? true);
                      },
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Generate Flashcards",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                      child: const Text("Generate Note!"), onPressed: () {})
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });
  Widget child;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: [ColorConstants.primaryColor, ColorConstants.lightBlue])),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          onPressed: onPressed,
          child: child),
    );
  }
}
