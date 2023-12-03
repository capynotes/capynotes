import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/audio_model.dart';
import '../../services/audio_service.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit(this.service) : super(AudioInitial());
  final AudioService service;

  Future<void> getMyAudios() async {
    emit(AudioLoading());
    List<AudioModel>? myAudios = await service.getMyAudios();
    if (myAudios == null) {
      emit(AudioError("Error", "Error"));
    } else if (myAudios.isEmpty) {
      emit(AudioNotFound());
    } else {
      emit(AudioDisplay(myAudios: myAudios));
    }
  }
}
