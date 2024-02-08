import 'package:accordion/accordion.dart';
import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/view/widgets/loading_lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../viewmodel/note_cubit/note_cubit.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
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
          return Scaffold(
              appBar: AppBar(
                  title: const Text("Note Screen"),
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
                          path: context
                              .read<NoteCubit>()
                              .path, //Change with selected note's path
                          // player: context.read<NoteCubit>().player,
                        ),
                        const SizedBox(height: 16.0),
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
                                  content: const Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")),
                              AccordionSection(
                                header: const Text("Transcript"),
                                content: const SingleChildScrollView(
                                  child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
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
                        //TODO: if flashcardset list not null
                        false
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
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: const BorderSide(
                                              color: Colors.grey)),
                                      title: const Text("Flashcard Set Title"),
                                      subtitle: const Text("Card Count"),
                                      dense: true,
                                      trailing: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            context.router
                                                .pushNamed("/edit-flashcard/1");
                                          }),
                                      onTap: () {
                                        //TODO: Navigate to flashcard set screen
                                        context.router
                                            .navigateNamed("/flashcard/1");
                                      },
                                    ),
                                  );
                                },
                                itemCount: 14)
                      ],
                    ),
                  ),
                ),
              ));
        } else if (state is NoteLoading) {
          return const LoadingLottie();
        } else if (state is NoteNotFound) {
          return const Center(child: Text("Note not found"));
        } else {
          return const Center(child: Text("Error"));
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
