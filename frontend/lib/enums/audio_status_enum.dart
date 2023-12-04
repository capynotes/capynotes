// ignore_for_file: constant_identifier_names

import 'package:easy_localization/easy_localization.dart';

import '../translations/locale_keys.g.dart';

enum AudioStatus { NO_REQUEST, PENDING, DONE, ERROR }

extension AudioStatusExtension on AudioStatus {
  String get name {
    switch (this) {
      case AudioStatus.NO_REQUEST:
        return LocaleKeys.enum_names_audio_status_no_request.tr();
      case AudioStatus.PENDING:
        return LocaleKeys.enum_names_audio_status_pending.tr();
      case AudioStatus.DONE:
        return LocaleKeys.enum_names_audio_status_done.tr();
      case AudioStatus.ERROR:
        return LocaleKeys.enum_names_audio_status_error.tr();
      default:
        return "Something's wrong";
    }
  }
}

AudioStatus getAudioStatusFromString(String statusString) {
  switch (statusString) {
    case "NO_REQUEST":
      return AudioStatus.NO_REQUEST;
    case "PENDING":
      return AudioStatus.PENDING;
    case "DONE":
      return AudioStatus.DONE;
    case "ERROR":
      return AudioStatus.ERROR;
    default:
      throw Exception("Invalid status string: $statusString");
  }
}
