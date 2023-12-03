part of 'audio_cubit.dart';

sealed class AudioState {}

final class AudioInitial extends AudioState {}

final class AudioLoading extends AudioState {}

final class AudioDisplay extends AudioState {
  List<AudioModel> myAudios;
  AudioDisplay({required this.myAudios});
}

final class AudioNotFound extends AudioState {}

final class AudioError extends AudioState {
  final String title;
  final String description;

  AudioError(this.title, this.description);
}

final class AudioSuccess extends AudioState {
  final String title;
  final String description;

  AudioSuccess(this.title, this.description);
}
