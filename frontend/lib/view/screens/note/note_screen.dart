import 'package:accordion/accordion.dart';
import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/screens/note/note_pdf_screen.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:simple_tags/simple_tags.dart';

import '../../../constants/asset_paths.dart';
import '../../../constants/colors.dart';
import '../../../enums/note_status_enum.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../utility/utils.dart';
import '../../../viewmodel/note_cubit/note_cubit.dart';
import '../../widgets/custom_widgets/custom_dialogs.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
import '../../widgets/flashcard_set_tile_widget.dart';
import '../../widgets/lotties/default_lottie_widget.dart';
import '../../widgets/play_audio/player_widget.dart';

@RoutePage()
class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, @PathParam('id') required this.noteID});
  final int noteID;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteState>(
      bloc: context.read<NoteCubit>()..getNote(widget.noteID),
      listener: (context, state) {
        if (state is NoteError) {
          CustomSnackbars.displayErrorMotionToast(
              context,
              state.title,
              state.description,
              () => context.read<NoteCubit>().getNote(widget.noteID));
        } else if (state is NoteSuccess) {
          CustomSnackbars.displaySuccessMotionToast(
              context,
              state.title,
              state.description,
              () => context.read<NoteCubit>().getNote(widget.noteID));
        } else if (state is NoteCrossDisplay) {
          Dialogs.materialDialog(
            context: context,
            barrierDismissible: true,
            onClose: (value) {
              context.read<NoteCubit>().crossList = null;
              context.read<NoteCubit>().emitDisplay();
            },
            title: "Cross Referenced Notes",
            msg:
                "Below are the cross referenced notes with current one, you can select one to view.",
            customViewPosition: CustomViewPosition.BEFORE_ACTION,
            customView: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: context.read<NoteCubit>().crossList!.isNotEmpty
                    ? List.generate(
                        context.read<NoteCubit>().crossList?.length ?? 0,
                        (index) => ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              tileColor: ColorConstants.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              leading: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: ColorConstants.lightBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.my_library_books,
                                color: ColorConstants.lightBlue,
                              ),
                              title: Text(context
                                  .read<NoteCubit>()
                                  .crossList![index]
                                  .title!),
                              subtitle: RichText(
                                  text: TextSpan(
                                      text: LocaleKeys.labels_status.tr(),
                                      style: TextStyle(
                                          color: ColorConstants.lightBlue,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text: context
                                            .read<NoteCubit>()
                                            .crossList![index]
                                            .status!
                                            .name,
                                        style: TextStyle(
                                            color: context
                                                            .read<NoteCubit>()
                                                            .crossList![index]
                                                            .status ==
                                                        NoteStatus
                                                            .TRANSCRIBING ||
                                                    context
                                                            .read<NoteCubit>()
                                                            .crossList![index]
                                                            .status ==
                                                        NoteStatus.SUMMARIZING
                                                ? ColorConstants.lightBlue
                                                : context
                                                            .read<NoteCubit>()
                                                            .crossList![index]
                                                            .status ==
                                                        NoteStatus.DONE
                                                    ? const Color.fromARGB(
                                                        255, 0, 255, 8)
                                                    : Colors.red,
                                            fontWeight: FontWeight.normal))
                                  ])),
                              onTap: () {
                                if (context
                                        .read<NoteCubit>()
                                        .crossList![index]
                                        .status ==
                                    NoteStatus.DONE) {
                                  context.router.navigateNamed(
                                      "/note/${context.read<NoteCubit>().crossList![index].id}");
                                }
                                Navigator.pop(context);
                              },
                            ))
                    : [Text("No Cross References Found")],
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is NoteDisplay || state is NoteCrossDisplay) {
          AudioPlayer player = AudioPlayer();
          return Scaffold(
              appBar: AppBar(
                  title: Text(
                      context.read<NoteCubit>().selectedNote!.note!.title ??
                          "No Title"),
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
                          path:
                              context.read<NoteCubit>().selectedNote!.audioUrl!,
                          player: player,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomElevatedButton(
                              child: const Text("View PDF"),
                              onPressed: () => kIsWeb
                                  ? Utils.launchURL(context
                                          .read<NoteCubit>()
                                          .selectedNote!
                                          .note!
                                          .pdfKey ??
                                      'http://denninginstitute.com/pjd/PUBS/CACMcols/cacmSep23.pdf')
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => NotePDFScreen(
                                          url: context
                                                  .read<NoteCubit>()
                                                  .selectedNote!
                                                  .note!
                                                  .pdfKey ??
                                              'http://denninginstitute.com/pjd/PUBS/CACMcols/cacmSep23.pdf',
                                          noteName: context
                                                  .read<NoteCubit>()
                                                  .selectedNote!
                                                  .note!
                                                  .title ??
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
                            const SizedBox(width: 8.0),
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
                                  content: Markdown(
                                      physics: NeverScrollableScrollPhysics(),
                                      selectable: true,
                                      shrinkWrap: true,
                                      data: context
                                              .read<NoteCubit>()
                                              .selectedNote!
                                              .summary
                                              ?.summary ??
                                          "No Summary")),
                              AccordionSection(
                                header: const Text("Transcript"),
                                content: SingleChildScrollView(
                                    child: RichText(
                                        text: TextSpan(
                                            children: List.generate(
                                                context
                                                        .read<NoteCubit>()
                                                        .selectedNote!
                                                        .transcript
                                                        ?.timestamps!
                                                        .length ??
                                                    0,
                                                (index) => TextSpan(
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      text:
                                                          "${context.read<NoteCubit>().selectedNote!.transcript?.timestamps![index].phrase}",
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              player.seek(Duration(
                                                                  seconds: context
                                                                          .read<
                                                                              NoteCubit>()
                                                                          .selectedNote!
                                                                          .transcript
                                                                          ?.timestamps![
                                                                              index]
                                                                          .start!
                                                                          .toInt() ??
                                                                      0,
                                                                  milliseconds: int.parse(context
                                                                          .read<
                                                                              NoteCubit>()
                                                                          .selectedNote!
                                                                          .transcript
                                                                          ?.timestamps![
                                                                              index]
                                                                          .start!
                                                                          .toString()
                                                                          .split(
                                                                              ".")[1] ??
                                                                      "0")));
                                                            },
                                                    ))))),
                              ),
                              AccordionSection(
                                  header: const Text("Tags"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      context
                                              .read<NoteCubit>()
                                              .selectedNote!
                                              .note!
                                              .tags!
                                              .isNotEmpty
                                          ? SimpleTags(
                                              onTagPress: (tag) {
                                                context
                                                    .read<NoteCubit>()
                                                    .getCrossReferenced(
                                                        tag.substring(1));
                                              },
                                              content: context
                                                  .read<NoteCubit>()
                                                  .selectedNote!
                                                  .note!
                                                  .tags!
                                                  .map((e) => "#${e.name!}")
                                                  .toList(),
                                              wrapSpacing: 4,
                                              tagTextSoftWrap: true,
                                              tagTextMaxlines: 1,
                                              wrapRunSpacing: 4,
                                              tagContainerPadding:
                                                  EdgeInsets.all(6),
                                              tagTextStyle: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                              tagContainerDecoration:
                                                  BoxDecoration(
                                                color: ColorConstants.lightBlue,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              "No tags added. Please add a tag below."),
                                      SizedBox(height: 8.0),
                                      IconsButton(
                                          iconData: Icons.tag,
                                          text: "Add Tag",
                                          onPressed: () {
                                            final formKey =
                                                GlobalKey<FormState>();
                                            CustomDialogs
                                                .showSinglePropFormDialog(
                                              context: context,
                                              formKey: formKey,
                                              title: "Add Tag",
                                              label: "Tag Name",
                                              controller: context
                                                  .read<NoteCubit>()
                                                  .tagController,
                                              onConfirm: () {
                                                context
                                                    .read<NoteCubit>()
                                                    .addTagToNote();
                                              },
                                            );
                                          }),
                                    ],
                                  )),
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
                        context
                                .read<NoteCubit>()
                                .selectedNote!
                                .note!
                                .cardSets!
                                .isEmpty
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
                                      flashcardSet: context
                                          .read<NoteCubit>()
                                          .selectedNote!
                                          .note!
                                          .cardSets![index]);
                                },
                                itemCount: context
                                        .read<NoteCubit>()
                                        .selectedNote!
                                        .note!
                                        .cardSets
                                        ?.length ??
                                    0)
                      ],
                    ),
                  ),
                ),
              ));
        } else if (state is NoteLoading || state is NoteCrossCheck) {
          return Scaffold(
            body: DefaultLottie(path: AssetPaths.loadingLottie),
          );
        } else if (state is NoteNotFound) {
          return const Center(child: Text("Note not found"));
        } else {
          return Scaffold(body: const Center(child: Text("")));
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
