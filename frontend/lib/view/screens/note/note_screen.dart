import 'package:accordion/accordion.dart';
import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/screens/note/note_pdf_screen.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../constants/asset_paths.dart';
import '../../../constants/colors.dart';
import '../../../utility/utils.dart';
import '../../../viewmodel/note_cubit/note_cubit.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
import '../../widgets/flashcard_set_tile_widget.dart';
import '../../widgets/lotties/default_lottie_widget.dart';
import '../../widgets/play_audio/player_widget.dart';

@RoutePage()
class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key, @PathParam('id') required this.noteID});
  final int noteID;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteState>(
      bloc: context.read<NoteCubit>()..getNote(noteID),
      listener: (context, state) {
        if (state is NoteError) {
          CustomSnackbars.displayErrorMotionToast(
              context,
              state.title,
              state.description,
              () => context.read<NoteCubit>().getNote(noteID));
        } else if (state is NoteSuccess) {
          CustomSnackbars.displaySuccessMotionToast(
              context,
              state.title,
              state.description,
              () => context.read<NoteCubit>().getNote(noteID));
        }
      },
      builder: (context, state) {
        if (state is NoteDisplay) {
          AudioPlayer player = AudioPlayer();
          return Scaffold(
              appBar: AppBar(
                  title: Text(state.note.note!.title ?? "No Title"),
                  centerTitle: true,
                  backgroundColor: ColorConstants.primaryColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<NoteCubit>().getMyNotes();
                    },
                  )),
              endDrawer: CustomDrawer(),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PlayerWidget(
                          path: state.note.audioUrl!,
                          player: player,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomElevatedButton(
                              child: const Text("View PDF"),
                              onPressed: () => kIsWeb
                                  ? Utils.launchURL(state.note.note!.pdfName ??
                                      'http://denninginstitute.com/pjd/PUBS/CACMcols/cacmSep23.pdf')
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => NotePDFScreen(
                                          url: state.note.note!.pdfName ??
                                              'http://denninginstitute.com/pjd/PUBS/CACMcols/cacmSep23.pdf',
                                          noteName: state.note.note!.title ??
                                              "No Title",
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 8.0),
                            CustomElevatedButton(
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Download PDF"),
                                    SizedBox(width: 8.0),
                                    Icon(
                                      Icons.download,
                                    ),
                                  ],
                                ),
                                onPressed: () {}),
                          ],
                        ),
                        Accordion(
                            headerBorderColor: Colors.blueGrey,
                            headerBorderColorOpened: Colors.transparent,
                            headerBorderWidth: 1,
                            headerBackgroundColorOpened: Colors.green,
                            headerBackgroundColor: ColorConstants.lightBlue,
                            contentBackgroundColor: Colors.white,
                            contentBorderColor: Colors.green,
                            contentBorderWidth: 3,
                            contentHorizontalPadding: 20,
                            scaleWhenAnimating: true,
                            openAndCloseAnimation: true,
                            headerPadding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            disableScrolling: true,
                            children: [
                              AccordionSection(
                                  header: const Text("Summary"),
                                  content: Text(state.note.summary?.summary ??
                                      "No Summary")),
                              AccordionSection(
                                header: const Text("Transcript"),
                                content: SingleChildScrollView(
                                    child: RichText(
                                        text: TextSpan(
                                            children: List.generate(
                                                state.note.transcript
                                                        ?.timestamps!.length ??
                                                    0,
                                                (index) => TextSpan(
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      text:
                                                          "${state.note.transcript?.timestamps![index].phrase}",
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              player.seek(Duration(
                                                                  seconds: state
                                                                          .note
                                                                          .transcript
                                                                          ?.timestamps![
                                                                              index]
                                                                          .start!
                                                                          .toInt() ??
                                                                      0,
                                                                  milliseconds: int.parse(state
                                                                          .note
                                                                          .transcript
                                                                          ?.timestamps![
                                                                              index]
                                                                          .start!
                                                                          .toString()
                                                                          .split(
                                                                              ".")[1] ??
                                                                      "0")));
                                                            },
                                                    ))))
                                    //     Text(
                                    //   state.note.transcript?.transcription ??
                                    //       "No Transcript",
                                    // )
                                    ),
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Flashcard Sets",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CreateFlashcardSetDialog(
                                            controller: context
                                                .read<NoteCubit>()
                                                .fcSetNameController);
                                      });
                                })
                          ],
                        ),
                        state.note.note!.cardSets!.isEmpty
                            ? Column(
                                children: [
                                  const Text("No Flashcard Sets Found"),
                                  CustomElevatedButton(
                                      child: const Text("Create Flashcard Set"),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CreateFlashcardSetDialog(
                                                  controller: context
                                                      .read<NoteCubit>()
                                                      .fcSetNameController);
                                            });
                                      }),
                                ],
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return FlashcardSetTile(
                                      flashcardSet:
                                          state.note.note!.cardSets![index]);
                                },
                                itemCount:
                                    state.note.note!.cardSets?.length ?? 0)
                      ],
                    ),
                  ),
                ),
              ));
        } else if (state is NoteLoading) {
          return DefaultLottie(path: AssetPaths.loadingLottie);
        } else if (state is NoteNotFound) {
          return const Center(child: Text("Note not found"));
        } else {
          return const Center(child: Text(""));
        }
      },
    );
  }
}

class CreateFlashcardSetDialog extends StatelessWidget {
  CreateFlashcardSetDialog({super.key, required this.controller});
  final TextEditingController controller;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                decoration:
                    const InputDecoration(labelText: "Flashcard Set Title"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title cannot be empty";
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: const Text(
                  "Create Set",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<NoteCubit>().createFlashcardSet();
                    Navigator.pop(context);
                  }
                }),
          ]),
    );
  }
}
