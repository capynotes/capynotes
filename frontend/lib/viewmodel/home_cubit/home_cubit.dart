import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/folder/add_folder_main_model.dart';
import '../../model/folder/folder_model.dart';
import '../../model/user/user_info_model.dart';
import '../../services/folder_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.service) : super(HomeInitial());
  final FolderService service;
  TextEditingController createFolderController = TextEditingController();
  Future<void> getHomeContents() async {
    List<dynamic>? allHomeContents;
    emit(HomeLoading());
    allHomeContents = await service.getHomeContents();
    if (allHomeContents == null) {
      emit(HomeNotFound());
    } else {
      emit(HomeDisplay(
        allHomeContents: allHomeContents,
      ));
    }
  }

  Future<void> createFolder() async {
    emit(HomeLoading());
    AddFolderMainModel addFolderModel = AddFolderMainModel(
      userId: UserInfo.loggedUser!.id,
      title: createFolderController.text,
    );
    FolderModel? result = await service.createFolder(addFolderModel);
    if (result == null) {
      emit(HomeError("Creation Failed", "Could not create folder"));
    } else {
      emit(HomeSuccess("Folder Created Successfully",
          "Folder \"${result.title}\" Created Successfully"));
    }
  }
}
