// ignore_for_file: constant_identifier_names

import 'package:easy_localization/easy_localization.dart';

import '../translations/locale_keys.g.dart';

enum NoteStatus { NO_REQUEST, PENDING, TRANSCRIBING, SUMMARIZING, DONE, ERROR }

extension NoteStatusExtension on NoteStatus {
  String get name {
    switch (this) {
      case NoteStatus.NO_REQUEST:
        return LocaleKeys.enum_names_audio_status_no_request.tr();
      case NoteStatus.PENDING:
        return LocaleKeys.enum_names_audio_status_pending.tr();
      case NoteStatus.TRANSCRIBING:
        return "Transcribing";
      case NoteStatus.SUMMARIZING:
        return "Summarizing";
      case NoteStatus.DONE:
        return LocaleKeys.enum_names_audio_status_done.tr();
      case NoteStatus.ERROR:
        return LocaleKeys.enum_names_audio_status_error.tr();
      default:
        return "Something's wrong";
    }
  }

  String get toJson {
    switch (this) {
      case NoteStatus.NO_REQUEST:
        return "NO_REQUEST";
      case NoteStatus.PENDING:
        return "PENDING";
      case NoteStatus.TRANSCRIBING:
        return "TRANSCRIBING";
      case NoteStatus.SUMMARIZING:
        return "SUMMARIZING";
      case NoteStatus.DONE:
        return "DONE";
      case NoteStatus.ERROR:
        return "ERROR";
      default:
        return "Something's wrong";
    }
  }
}

NoteStatus getNoteStatusFromString(String statusString) {
  switch (statusString) {
    case "NO_REQUEST":
      return NoteStatus.NO_REQUEST;
    case "PENDING":
      return NoteStatus.PENDING;
    case "TRANSCRIBING":
      return NoteStatus.TRANSCRIBING;
    case "SUMMARIZING":
      return NoteStatus.SUMMARIZING;
    case "DONE":
      return NoteStatus.DONE;
    case "ERROR":
      return NoteStatus.ERROR;
    default:
      throw Exception("Invalid status string: $statusString");
  }
}
