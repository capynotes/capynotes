import 'package:accordion/accordion.dart';
import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/loading_lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../viewmodel/note_cubit/note_cubit.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';

@RoutePage()
class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key, @PathParam('id') required this.noteID});
  final int noteID;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteState>(
      bloc: context.read<NoteCubit>()..getNote(noteID),
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                title: const Text("Note Screen"),
                centerTitle: true,
                backgroundColor: ColorConstants.primaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<NoteCubit>().getMyNotes();
                    context.router.pop();
                  },
                )),
            endDrawer: CustomDrawer(),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                    return CreateFlashcardSetDialog();
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
                                          return CreateFlashcardSetDialog();
                                        });
                                  }),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(25.0, 0, 25, 0),
                            child: ListView.builder(
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
                                          onPressed: () {}),
                                      onTap: () {
                                        //TODO: Navigate to flashcard set screen
                                        context.router
                                            .navigateNamed("/flashcard/1");
                                      },
                                    ),
                                  );
                                },
                                itemCount: 14),
                          )
                  ],
                ),
              ),
            ));
        if (state is NoteDisplay) {
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
  const CreateFlashcardSetDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Flashcard Set Title"),
              ),
            ],
          ),
          actions: [
            TextButton(
                child: const Text(
                  "Create Set",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  // TODO: Send create flashcard set request
                }),
            TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]),
    );
  }
}
