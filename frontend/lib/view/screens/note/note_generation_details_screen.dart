import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/asset_paths.dart';
import '../../../constants/colors.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../viewmodel/note_generation_cubit/note_generation_cubit.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
import '../../widgets/custom_widgets/custom_text_form_field.dart';
import '../../widgets/lotties/default_lottie_widget.dart';

@RoutePage()
class NoteGenerationDetailsScreen extends StatelessWidget {
  NoteGenerationDetailsScreen(
      {super.key, @PathParam('src') required this.source});
  final String source;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            return DefaultLottie(path: AssetPaths.loadingLottie);
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: source == "youtube"
                      ? FromYoutubeWidget()
                      : source == "audio"
                          ? FromAudioFileWidget()
                          : source == "recording"
                              ? const FromRecordingWidget()
                              : // Error widget
                              Center(
                                  child: Container(
                                    child: Text("An Error Has Occured"),
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

class FromYoutubeWidget extends StatelessWidget {
  FromYoutubeWidget({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          DefaultLottie(path: AssetPaths.youtubeLottie),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            label: "Video URL",
            hint: "Enter Video URL",
            controller: context.read<NoteGenerationCubit>().videoUrlController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            label: LocaleKeys.text_fields_labels_note_name.tr(),
            hint: LocaleKeys.text_fields_hints_note_name.tr(),
            controller: context.read<NoteGenerationCubit>().noteNameController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<NoteGenerationCubit>().generateNoteFromFile();
                }
              },
              child: Text(LocaleKeys.buttons_generate_note.tr())),
        ],
      ),
    );
  }
}

class FromAudioFileWidget extends StatelessWidget {
  FromAudioFileWidget({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: DefaultLottie(path: AssetPaths.browseFolderLottie)),
          const SizedBox(
            height: 20,
          ),
          CustomElevatedButton(
            child: Text(LocaleKeys.buttons_browse_files_audio.tr()),
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
              Text(context.read<NoteGenerationCubit>().selectedFileName),
              if (context.read<NoteGenerationCubit>().audioFile != null)
                IconButton(
                  onPressed: () {
                    context.read<NoteGenerationCubit>().clearSelectedFile();
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                )
            ],
          ),
          CustomTextFormField(
            label: LocaleKeys.text_fields_labels_note_name.tr(),
            hint: LocaleKeys.text_fields_hints_note_name.tr(),
            controller: context.read<NoteGenerationCubit>().noteNameController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    context.read<NoteGenerationCubit>().audioFile != null) {
                  context.read<NoteGenerationCubit>().generateNoteFromFile();
                }
              },
              child: Text(LocaleKeys.buttons_generate_note.tr())),
        ],
      ),
    );
  }
}

class FromRecordingWidget extends StatelessWidget {
  const FromRecordingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: DefaultLottie(path: AssetPaths.microphoneLottie)),
        const SizedBox(
          height: 20,
        ),
        CustomElevatedButton(
          child: Text(LocaleKeys.buttons_record_audio.tr()),
          onPressed: () {
            context.read<NoteGenerationCubit>().recordAudio();
          },
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextFormField(
          label: LocaleKeys.text_fields_labels_note_name.tr(),
          hint: LocaleKeys.text_fields_hints_note_name.tr(),
          controller: context.read<NoteGenerationCubit>().noteNameController,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomElevatedButton(
            onPressed: () {
              context.read<NoteGenerationCubit>().generateNoteFromFile();
            },
            child: Text(LocaleKeys.buttons_generate_note.tr())),
      ],
    );
  }
}
