import 'dart:convert';

import 'package:capynotes/model/flashcard/add_flashcard_set_model.dart';
import 'package:capynotes/model/flashcard/flashcard_set_model.dart';
import 'package:capynotes/model/user/user_info_model.dart';
import 'package:http/http.dart';

import '../constants/api_constants.dart';
import '../model/base_response_model.dart';
import '../model/note_model.dart';
import 'api.dart';

class NoteService {
  Future<List<Note>?> getMyNotes() async {
    try {
      Response? response;
      response = await Api.instance.getRequest(ApiConstants.baseUrl,
          "${ApiConstants.getMyNotes}${UserInfo.loggedUser!.id}");
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        List<Note> noteList = [];
        for (var note in responseModel.data) {
          Note noteModel = Note.fromJson(note);
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

  Future<FlashcardSetModel?> createFlashcardSet(
      AddFlashcardSetModel requestBody) async {
    try {
      Response? response;
      response = await Api.instance.postRequest(ApiConstants.baseUrl,
          ApiConstants.createFlashcardSet, jsonEncode(requestBody.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        FlashcardSetModel flashcardSetModel =
            FlashcardSetModel.fromJson(responseModel.data);
        return flashcardSetModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
