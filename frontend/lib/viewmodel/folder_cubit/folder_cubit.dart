import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/folder_service.dart';

part 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit(this.service) : super(FolderInitial());
  final FolderService service;

  Future<void> getFolderContents(int id) async {
    List<dynamic>? allFolderContents;
    List<dynamic>? tempFolderContents;
    emit(FolderLoading());
    allFolderContents = await service.getFolderContents(id);
    if (allFolderContents == null) {
      emit(FolderNotFound());
    } else {
      tempFolderContents = allFolderContents;
      emit(FolderDisplay(
          allFolderContents: allFolderContents,
          tempFolderContents: tempFolderContents));
    }
  }
}
