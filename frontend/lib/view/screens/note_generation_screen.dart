import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:capynotes/viewmodel/note_generation_cubit/note_generation_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/asset_paths.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/custom_widgets/custom_drawer.dart';
import '../widgets/loading_lottie_widget.dart';

@RoutePage()
class NoteGenerationScreen extends StatefulWidget {
  const NoteGenerationScreen({super.key});

  @override
  State<NoteGenerationScreen> createState() => _NoteGenerationScreenState();
}

class _NoteGenerationScreenState extends State<NoteGenerationScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Text(
          LocaleKeys.appbars_titles_note_generation.tr(),
        ),
        centerTitle: true,
      ),
      endDrawer: CustomDrawer(),
      body: BlocConsumer<NoteGenerationCubit, NoteGenerationState>(
        listener: (context, state) {
          if (state is NoteGenerationSuccess) {
            CustomSnackbars.displaySuccessMotionToast(
                context, state.title, state.description, () {
              context.read<NoteGenerationCubit>().emitDisplay();
            });
          } else if (state is NoteGenerationError) {
            CustomSnackbars.displayErrorMotionToast(
                context, state.title, state.description, () {
              context.read<NoteGenerationCubit>().emitDisplay();
            });
          }
        },
        builder: (context, state) {
          if (state is NoteGenerationLoading) {
            return const LoadingLottie();
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: "Video URL",
                          hint: "Enter Video URL",
                          controller: context
                              .read<NoteGenerationCubit>()
                              .videoUrlController,
                        ),
                        CustomElevatedButton(
                          child: Text("Submit Video"),
                          onPressed: () {
                            context
                                .read<NoteGenerationCubit>()
                                .generateNoteFromURL();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(LocaleKeys.labels_or.tr(),
                            style: TextStyle(
                                fontSize: 24,
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.mic),
                                  Text(LocaleKeys.buttons_record_audio.tr())
                                ],
                              ),
                              // Column(
                              //   children: [
                              //     Image.asset(
                              //       AssetPaths.micImage,
                              //       color: ColorConstants.primaryColor,
                              //     ),
                              //     const SizedBox(
                              //       height: 20,
                              //     ),
                              //     Text(LocaleKeys.buttons_record_audio.tr()),
                              //     const SizedBox(
                              //       height: 10,
                              //     ),
                              //   ],
                              // ),
                            ),
                            onPressed: () {}),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(LocaleKeys.labels_or.tr(),
                            style: TextStyle(
                                fontSize: 24,
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                          child:
                              Text(LocaleKeys.buttons_browse_files_audio.tr()),
                          onPressed: () {
                            context.read<NoteGenerationCubit>().pickAudio();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(LocaleKeys.labels_selected_file_name.tr()),
                            Text(context
                                .read<NoteGenerationCubit>()
                                .selectedFileName),
                            if (context.read<NoteGenerationCubit>().audioFile !=
                                null)
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<NoteGenerationCubit>()
                                      .clearSelectedFile();
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: CheckboxListTile(
                            tileColor: ColorConstants.primaryColor,
                            side: BorderSide(
                                color: ColorConstants.lightBlue, width: 2),
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
                            title: Text(
                              LocaleKeys.buttons_generate_flashcards.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        CustomTextFormField(
                          label: LocaleKeys.text_fields_labels_note_name.tr(),
                          hint: LocaleKeys.text_fields_hints_note_name.tr(),
                          controller: context
                              .read<NoteGenerationCubit>()
                              .noteNameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  context
                                          .read<NoteGenerationCubit>()
                                          .audioFile !=
                                      null) {
                                context
                                    .read<NoteGenerationCubit>()
                                    .generateNoteFromFile();
                              }
                            },
                            child: Text(LocaleKeys.buttons_generate_note.tr())),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
