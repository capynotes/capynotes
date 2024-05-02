import 'package:capynotes/model/folder/folder_contents_model.dart';
import 'package:capynotes/model/folder/folder_model.dart';
import 'package:capynotes/model/user/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/folder/add_folder_main_model.dart';
import '../../services/folder_service.dart';

part 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit(this.service) : super(FolderInitial());
  final FolderService service;
  TextEditingController createFolderController = TextEditingController();

  Future<void> getFolderContents(int id) async {
    FolderContentsModel? allFolderContents;
    FolderContentsModel? tempFolderContents;
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

  Future<void> createFolderInFolder(int folderID) async {
    emit(FolderLoading());
    AddFolderMainModel addFolderModel = AddFolderMainModel(
      userId: UserInfo.loggedUser!.id,
      title: createFolderController.text,
    );
    FolderModel? result =
        await service.addFolderToFolder(addFolderModel, folderID);
    if (result == null) {
      emit(FolderError("Creation Failed", "Could not create folder"));
    } else {
      emit(FolderSuccess("Folder Created Successfully",
          "Folder \"${result.title}\" Created Successfully"));
    }
  }
}
