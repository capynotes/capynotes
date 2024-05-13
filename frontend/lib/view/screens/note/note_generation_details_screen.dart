import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_dialogs.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/asset_paths.dart';
import '../../../constants/colors.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../utility/utils.dart';
import '../../../viewmodel/note_generation_cubit/note_generation_cubit.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
import '../../widgets/custom_widgets/custom_text_form_field.dart';
import '../../widgets/lotties/default_lottie_widget.dart';

@RoutePage()
class NoteGenerationDetailsScreen extends StatelessWidget {
  NoteGenerationDetailsScreen(
      {super.key,
      @PathParam('src') required this.source,
      required this.folderID});
  final String source;
  final int folderID;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        context.read<NoteGenerationCubit>().clearCubit();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryColor,
          title: Text(
            LocaleKeys.appbars_titles_note_generation.tr(),
          ),
          centerTitle: true,
        ),
        endDrawer: CustomDrawer(),
        body: BlocConsumer<NoteGenerationCubit, NoteGenerationState>(
          bloc: context.read<NoteGenerationCubit>()..emitDisplay(),
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
            } else if (state is NoteGenerationConfirmRecording) {
              CustomDialogs.showConfirmDialog(context, "Confirm Recorded Audio",
                  "Are you sure you want to record the audio of ${Utils.durationToString(context.read<NoteGenerationCubit>().recordingDuration)}",
                  () {
                Navigator.pop(context);
                context.read<NoteGenerationCubit>().stopRecording();

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
                        ? FromYoutubeWidget(
                            folderID: folderID,
                          )
                        : source == "audio"
                            ? FromAudioFileWidget(
                                folderID: folderID,
                              )
                            : source == "recording"
                                ? FromRecordingWidget(
                                    folderID: folderID,
                                    state: state,
                                  )
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
      ),
    );
  }
}

class FromYoutubeWidget extends StatelessWidget {
  FromYoutubeWidget({super.key, required this.folderID});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int folderID;
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
                  context
                      .read<NoteGenerationCubit>()
                      .generateNoteFromURL(folderID: folderID);
                }
              },
              child: Text(LocaleKeys.buttons_generate_note.tr())),
        ],
      ),
    );
  }
}

class FromAudioFileWidget extends StatelessWidget {
  FromAudioFileWidget({super.key, required this.folderID});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int folderID;
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
                  context
                      .read<NoteGenerationCubit>()
                      .generateNoteFromFile(folderID);
                }
              },
              child: Text(LocaleKeys.buttons_generate_note.tr())),
        ],
      ),
    );
  }
}

class FromRecordingWidget extends StatelessWidget {
  FromRecordingWidget({super.key, required this.folderID, required this.state});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int folderID;
  NoteGenerationState state;

  @override
  Widget build(BuildContext context) {
    if (state is NoteGenerationRecording) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  context.read<NoteGenerationCubit>().pauseRecording();
                },
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  context.read<NoteGenerationCubit>().confirmRecording();
                },
              ),
            ],
          ),
          AudioWaveforms(
            size: Size(MediaQuery.of(context).size.width * 0.75, 200.0),
            recorderController:
                context.read<NoteGenerationCubit>().recordController,
            enableGesture: false,
            waveStyle: WaveStyle(
              scaleFactor: 100,
              waveColor: Colors.black,
              showMiddleLine: false,
              spacing: 8.0,
              bottomPadding: 50,
              showDurationLabel: true,
              extendWaveform: true,
            ),
          ),
        ],
      ));
    } else if (state is NoteGenerationPaused ||
        state is NoteGenerationConfirmRecording) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  context.read<NoteGenerationCubit>().resumeRecording();
                },
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  context.read<NoteGenerationCubit>().confirmRecording();
                },
              ),
            ],
          ),
          AudioWaveforms(
            size: Size(MediaQuery.of(context).size.width * 0.75, 200.0),
            recorderController:
                context.read<NoteGenerationCubit>().recordController,
            enableGesture: false,
            waveStyle: WaveStyle(
              scaleFactor: 100,
              waveColor: Colors.black,
              showMiddleLine: false,
              spacing: 8.0,
              bottomPadding: 50,
              showDurationLabel: true,
              extendWaveform: true,
            ),
          ),
        ],
      ));
    }
    // else if (state is NoteGenerationRecorded) {
    //   return Column(
    //     children: [
    //       IconButton(
    //           onPressed: () {
    //             context.read<NoteGenerationCubit>().startPlaying();
    //           },
    //           icon: Icon(Icons.play_arrow)),
    //       AudioFileWaveforms(
    //         size: Size(MediaQuery.of(context).size.width * 0.8, 200.0),
    //         playerController:
    //             context.read<NoteGenerationCubit>().playerController,
    //         playerWaveStyle: const PlayerWaveStyle(
    //           fixedWaveColor: Colors.white54,
    //           liveWaveColor: Colors.blueAccent,
    //           spacing: 6,
    //         ),
    //       ),
    //       TextButton(
    //           onPressed: () {
    //             context.read<NoteGenerationCubit>().emitDisplay();
    //           },
    //           child: Text("Confirm Recording"))
    //     ],
    //   );
    // }
    else {
      return Form(
        key: formKey,
        child: Column(
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
                context.read<NoteGenerationCubit>().startRecording();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            context.read<NoteGenerationCubit>().recordingPath != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "Recorded Audio Duration: ${Utils.durationToString(context.read<NoteGenerationCubit>().recordingDuration)}"),
                      IconButton(
                          onPressed: () {
                            context
                                .read<NoteGenerationCubit>()
                                .startRecording();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.green,
                          )),
                    ],
                  )
                : SizedBox.shrink(),
            CustomTextFormField(
                label: LocaleKeys.text_fields_labels_note_name.tr(),
                hint: LocaleKeys.text_fields_hints_note_name.tr(),
                controller:
                    context.read<NoteGenerationCubit>().noteNameController,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.validators_required
                        .tr(args: ["Note name"]);
                  } else if (context
                              .read<NoteGenerationCubit>()
                              .recordingPath ==
                          null ||
                      context.read<NoteGenerationCubit>().recordingPath == "") {
                    return "You must record an audio first!";
                  } else {
                    return null;
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() &&
                      context.read<NoteGenerationCubit>().recordingPath !=
                          null &&
                      context.read<NoteGenerationCubit>().recordingPath != "") {
                    context
                        .read<NoteGenerationCubit>()
                        .generateNoteFromRecording(folderID);
                  }
                },
                child: Text(LocaleKeys.buttons_generate_note.tr())),
          ],
        ),
      );
    }
  }
}
