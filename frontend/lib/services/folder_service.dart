// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:capynotes/model/folder/add_folder_main_model.dart';
import 'package:capynotes/model/folder/folder_model.dart';
import 'package:capynotes/model/folder/folder_with_count_model.dart';
import 'package:capynotes/model/folder/note_grid_model.dart';
import 'package:http/http.dart';

import '../constants/api_constants.dart';
import '../model/base_response_model.dart';
import '../model/user/user_info_model.dart';
import 'api.dart';

class FolderService {
  Future<FolderModel?> createFolder(AddFolderMainModel requestBody) async {
    try {
      Response? response;
      response = await Api.instance.postRequest(ApiConstants.baseUrl,
          ApiConstants.createFolder, jsonEncode(requestBody.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        FolderModel folderModel = FolderModel.fromJson(responseModel.data);
        return folderModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<FolderWithCountModel>?> getMainFolders() async {
    try {
      Response? response;
      response = await Api.instance.getRequest(ApiConstants.baseUrl,
          "${ApiConstants.getUserFolders}${UserInfo.loggedUser!.id}");
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        List<FolderWithCountModel> folderList = [];
        for (var folder in responseModel.data) {
          FolderWithCountModel folderWithCountModel =
              FolderWithCountModel.fromJson(folder);
          folderList.add(folderWithCountModel);
        }
        return folderList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<FolderModel?> addFolderToFolder(
      AddFolderMainModel requestBody, int folderID) async {
    try {
      Response? response;
      response = await Api.instance.postRequest(
          ApiConstants.baseUrl,
          "${ApiConstants.addFolderToFolder}${folderID}",
          jsonEncode(requestBody.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        FolderModel folderModel = FolderModel.fromJson(responseModel.data);
        return folderModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>?> getFolderContents(int folderID) async {
    try {
      Response? response;
      response = await Api.instance.getRequest(
          ApiConstants.baseUrl, "${ApiConstants.getFolder}$folderID");
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        List<dynamic> itemList = [];
        for (var item in responseModel.data) {
          if (item["status"] == null) {
            FolderWithCountModel folderWithCountModel =
                FolderWithCountModel.fromJson(item);
            itemList.add(folderWithCountModel);
          } else {
            NoteGridModel noteGridModel = NoteGridModel.fromJson(item);
            itemList.add(noteGridModel);
          }
        }
        return itemList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
