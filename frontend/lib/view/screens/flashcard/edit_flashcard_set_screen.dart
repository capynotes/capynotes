import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_dialogs.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:capynotes/view/widgets/loading_lottie_widget.dart';
import 'package:capynotes/viewmodel/flashcard_cubit/flashcard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';

@RoutePage()
class EditFlashcardSetScreen extends StatelessWidget {
  const EditFlashcardSetScreen(
      {super.key, @PathParam('id') required this.setID});
  final int setID;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlashcardCubit, FlashcardState>(
      bloc: context.read<FlashcardCubit>()..getFlashcardSet(id: setID),
      listener: (context, state) {
        if (state is FlashcardSuccess) {
          CustomSnackbars.displaySuccessMotionToast(
              context,
              state.title,
              state.description,
              () =>
                  {context.read<FlashcardCubit>().getFlashcardSet(id: setID)});
        } else if (state is FlashcardError) {
          CustomSnackbars.displayErrorMotionToast(
              context, state.title, state.description, () => {});
        }
      },
      builder: (context, state) {
        if (state is FlashcardDisplay) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.read<FlashcardCubit>().flashcards!.title ??
                  'Error Loading Flashcards'),
              centerTitle: true,
              backgroundColor: ColorConstants.primaryColor,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final formKey = GlobalKey<FormState>();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: const Text("Add Flashcard"),
                          titlePadding:
                              const EdgeInsets.fromLTRB(60, 24, 60, 0),
                          content: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextFormField(
                                    label: "Front",
                                    controller: context
                                        .read<FlashcardCubit>()
                                        .frontController,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextFormField(
                                      label: "Back",
                                      controller: context
                                          .read<FlashcardCubit>()
                                          .backController)
                                ],
                              )),
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
                                    context
                                        .read<FlashcardCubit>()
                                        .addFlashcard(id: setID);
                                    Navigator.pop(context);
                                  }
                                }),
                          ]);
                    });
              },
              backgroundColor: ColorConstants.primaryColor,
              child: const Icon(Icons.add),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.extent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    for (int i = 0;
                        i <
                            context
                                .read<FlashcardCubit>()
                                .allFlashcardList
                                .length;
                        i++)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              // height: MediaQuery.of(context).size.height * 0.2,
                              flex: 10,
                              child: context
                                  .read<FlashcardCubit>()
                                  .allFlashcardList[i]),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      final editFormKey =
                                          GlobalKey<FormState>();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Edit Flashcard"),
                                              content: Form(
                                                key: editFormKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CustomTextFormField(
                                                      label: "Front",
                                                      controller: context
                                                          .read<
                                                              FlashcardCubit>()
                                                          .editFrontController,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    CustomTextFormField(
                                                      label: "Back",
                                                      controller: context
                                                          .read<
                                                              FlashcardCubit>()
                                                          .editBackController,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel")),
                                                TextButton(
                                                    onPressed: () {
                                                      if (editFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        context
                                                            .read<
                                                                FlashcardCubit>()
                                                            .editFlashcard(
                                                                id: context
                                                                    .read<
                                                                        FlashcardCubit>()
                                                                    .flashcards!
                                                                    .cards![i]
                                                                    .id!);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Edit")),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text("Edit")),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      CustomDialogs.showConfirmDialog(
                                          context,
                                          "Confirm Delete Flashcard",
                                          "Are you sure you want to delete this flashcard?",
                                          () {
                                        context
                                            .read<FlashcardCubit>()
                                            .deleteFlashcard(
                                                id: context
                                                    .read<FlashcardCubit>()
                                                    .flashcards!
                                                    .cards![i]
                                                    .id!);
                                        Navigator.pop(context);
                                        context
                                            .read<FlashcardCubit>()
                                            .getFlashcardSet(id: setID);
                                      });
                                    },
                                    child: Text("Delete",
                                        style: TextStyle(color: Colors.white))),
                              ],
                            ),
                          )
                        ],
                      )
                  ]),
            ),
          );
        } else if (state is FlashcardLoading) {
          return const LoadingLottie();
        } else {
          return const Center(child: Text(""));
        }
      },
    );
  }
}
