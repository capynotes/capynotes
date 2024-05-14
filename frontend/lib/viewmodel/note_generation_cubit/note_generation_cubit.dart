import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:capynotes/model/note_model.dart';
import 'package:capynotes/model/user/user_info_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:capynotes/services/note_generation_service.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:io';

import '../../model/video_model.dart';
import '../../translations/locale_keys.g.dart';

part 'note_generation_state.dart';

class NoteGenerationCubit extends Cubit<NoteGenerationState> {
  NoteGenerationCubit(this.service) : super(NoteGenerationInitial());
  NoteGenerationService service;

  // bool isGenerateFlashcards = true;
  TextEditingController noteNameController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();
  String selectedFileName = LocaleKeys.labels_no_file_selected.tr();
  PlatformFile? audioFile;
  PlatformFile? platformFile;
  String? selectedFileExtension;
  Note? generatedNote;

  RecorderController recordController = RecorderController();
  PlayerController playerController = PlayerController();
  String? recordingPath;
  Duration recordingDuration = Duration.zero;

  void clearCubit() {
    noteNameController.text = "";
    videoUrlController.text = "";
    selectedFileName = LocaleKeys.labels_no_file_selected.tr();
    audioFile = null;
    platformFile = null;
    selectedFileExtension = "";
    generatedNote = null;
    recordController.reset();
    playerController.release();
    recordingPath = null;
    recordingDuration = Duration.zero;
  }

  Future<void> pickAudio() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withReadStream: true);

    if (result != null) {
      emit(NoteGenerationCheck());
      audioFile = result.files.single;
      selectedFileName = result.files.single.name;
      platformFile = result.files.single;
      selectedFileExtension = platformFile!.extension;

      emit(NoteGenerationSuccess(
          LocaleKeys.dialogs_success_dialogs_file_pick_success_title.tr(),
          LocaleKeys.dialogs_success_dialogs_file_pick_success_description
              .tr(args: [selectedFileName])));
    } else {
      selectedFileName = LocaleKeys.labels_no_file_selected.tr();
      audioFile = null;
      platformFile = null;
      selectedFileExtension = null;
      emit(NoteGenerationError(
          LocaleKeys.dialogs_error_dialogs_file_pick_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_file_pick_error_description.tr()));
    }
  }

  Future<void> startRecording() async {
    await recordController.record();
    emit(NoteGenerationRecording());
  }

  Future<void> pauseRecording() async {
    await recordController.pause();
    emit(NoteGenerationPaused());
  }

  Future<void> resumeRecording() async {
    await recordController.record();
    emit(NoteGenerationRecording());
  }

  void confirmRecording() async {
    await recordController.pause();
    recordingDuration = recordController.elapsedDuration;
    emit(NoteGenerationConfirmRecording());
  }

  Future<void> stopRecording() async {
    recordingDuration = recordController.elapsedDuration;
    recordingPath = await recordController.stop(false);
    emit(NoteGenerationDisplay());
  }

  Future<void> startPlaying() async {
    await playerController.preparePlayer(
      path: recordingPath!,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
    print(recordingPath);
    playerController.startPlayer(finishMode: FinishMode.stop);
  }

  void deleteFile(String filePath) async {
    try {
      // Create a File object with the given file path
      File file = File(filePath);

      // Check if the file exists
      if (await file.exists()) {
        // Delete the file
        await file.delete();
        print('File deleted successfully.');
      } else {
        print('File does not exist.');
      }
    } catch (e) {
      print('Error while deleting file: $e');
    }
  }

  Future<void> generateNoteFromFile(int folderID) async {
    emit(NoteGenerationLoading());
    try {
      DateTime now = DateTime.now();

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile!.readStream!,
          size: platformFile!.size,
        ),
        key:
            "${now.toIso8601String()}_${noteNameController.text.replaceAll(RegExp(r' '), '')}.${selectedFileExtension!}",
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
      Note? response;
      if (folderID == 0) {
        response = await service.addNoteToHome(
            noteModel: GenerateNoteFromFileModel(
          title: noteNameController.text,
          audioKey: result.uploadedItem.key,
          userId: UserInfo.loggedUser!.id,
        ));
      } else {
        response = await service.addNoteToFolder(
            noteModel: GenerateNoteFromFileModel(
              title: noteNameController.text,
              audioKey: result.uploadedItem.key,
              userId: UserInfo.loggedUser!.id,
            ),
            folderID: folderID);
      }
      if (response != null) {
        generatedNote = response;
        emit(NoteGenerationSuccess(
            LocaleKeys.dialogs_success_dialogs_note_generation_success_title
                .tr(),
            generatedNote!.title ?? ""));
      } else {
        emit(NoteGenerationError(
            LocaleKeys.dialogs_error_dialogs_note_generation_error_title.tr(),
            LocaleKeys.dialogs_error_dialogs_note_generation_error_description
                .tr()));
      }
    } on StorageException catch (e) {
      safePrint('Error uploading file: $e');
      rethrow;
    }
  }

  Future<void> generateNoteFromURL({required int folderID}) async {
    emit(NoteGenerationLoading());
    VideoModel videoModel = VideoModel(
        url: videoUrlController.text,
        noteName: noteNameController.text,
        userId: UserInfo.loggedUser!.id,
        folderID: folderID);

    var response = await service.generateNoteFromURL(videoModel);

    if (response != null) {
      generatedNote = response;
      emit(NoteGenerationSuccess(
          LocaleKeys.dialogs_success_dialogs_note_generation_success_title.tr(),
          generatedNote!.title ?? ""));
    } else {
      emit(NoteGenerationError(
          LocaleKeys.dialogs_error_dialogs_note_generation_error_title.tr(),
          LocaleKeys.dialogs_error_dialogs_note_generation_error_description
              .tr()));
    }
  }

  Future<void> generateNoteFromRecording(int folderID) async {
    emit(NoteGenerationLoading());
    try {
      DateTime now = DateTime.now();
      final recordingFile = AWSFile.fromPath(recordingPath!);

      final result = await Amplify.Storage.uploadFile(
        localFile: recordingFile,
        key:
            "${now.toIso8601String()}_${noteNameController.text.replaceAll(RegExp(r' '), '')}.m4a",
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
      Note? response;
      if (folderID == 0) {
        response = await service.addNoteToHome(
            noteModel: GenerateNoteFromFileModel(
          title: noteNameController.text,
          audioKey: result.uploadedItem.key,
          userId: UserInfo.loggedUser!.id,
        ));
      } else {
        response = await service.addNoteToFolder(
            noteModel: GenerateNoteFromFileModel(
              title: noteNameController.text,
              audioKey: result.uploadedItem.key,
              userId: UserInfo.loggedUser!.id,
            ),
            folderID: folderID);
      }
      if (response != null) {
        generatedNote = response;
        emit(NoteGenerationSuccess(
            LocaleKeys.dialogs_success_dialogs_note_generation_success_title
                .tr(),
            generatedNote!.title ?? ""));
      } else {
        emit(NoteGenerationError(
            LocaleKeys.dialogs_error_dialogs_note_generation_error_title.tr(),
            LocaleKeys.dialogs_error_dialogs_note_generation_error_description
                .tr()));
      }
    } on StorageException catch (e) {
      safePrint('Error uploading file: $e');
      rethrow;
    }
  }

  void emitDisplay() {
    emit(NoteGenerationDisplay());
  }

  // void changeGenerateFlashcards(bool value) {
  //   emit(NoteGenerationCheck());
  //   isGenerateFlashcards = value;
  //   emit(NoteGenerationDisplay());
  // }

  void clearSelectedFile() {
    emit(NoteGenerationCheck());
    selectedFileName = LocaleKeys.labels_no_file_selected.tr();
    audioFile = null;
    platformFile = null;
    emit(NoteGenerationDisplay());
  }
}
