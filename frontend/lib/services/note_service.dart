import 'dart:convert';

import 'package:capynotes/model/user/user_info_model.dart';
import 'package:http/http.dart';

import '../constants/api_constants.dart';
import '../model/base_response_model.dart';
import '../model/note_model.dart';
import 'api.dart';

class NoteService {
  Future<List<NoteModel>?> getMyNotes() async {
    try {
      Response? response;
      response = await Api.instance.getRequest(ApiConstants.baseUrl,
          "${ApiConstants.getMyNotes}${UserInfo.loggedUser!.id}");
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        List<NoteModel> noteList = [];
        for (var note in responseModel.data) {
          NoteModel noteModel = NoteModel.fromJson(note);
          noteList.add(noteModel);
        }
        return noteList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<NoteModel?> getNote(int id) async {
    try {
      Response? response;
      response = await Api.instance
          .getRequest(ApiConstants.baseUrl, "${ApiConstants.getNote}$id");
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        NoteModel noteModel = NoteModel.fromJson(responseModel.data);
        return noteModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
