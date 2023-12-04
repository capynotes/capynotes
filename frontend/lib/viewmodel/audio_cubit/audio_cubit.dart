import 'package:capynotes/enums/audio_status_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/audio_model.dart';
import '../../services/audio_service.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit(this.service) : super(AudioInitial());
  final AudioService service;

  Future<void> getMyAudios() async {
    emit(AudioLoading());
    List<AudioModel>? allAudios = await service.getMyAudios();
    if (allAudios == null) {
      emit(AudioError("Error", "Error"));
    } else if (allAudios.isEmpty) {
      emit(AudioNotFound());
    } else {
      List<AudioModel>? pendingAudios = allAudios
          .where((element) => element.status == AudioStatus.PENDING)
          .toList();
      List<AudioModel>? doneAudios = allAudios
          .where((element) => element.status == AudioStatus.DONE)
          .toList();
      emit(AudioDisplay(
          pendingAudios: pendingAudios,
          doneAudios: doneAudios,
          allAudios: allAudios));
    }
  }
}
