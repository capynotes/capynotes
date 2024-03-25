import 'dart:convert';

import 'package:capynotes/constants/api_constants.dart';
import 'package:capynotes/model/base_response_model.dart';
import 'package:capynotes/model/note_model.dart';
import 'package:capynotes/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:http/http.dart';

import '../model/video_model.dart';

class NoteGenerationService {
  //TODO: refactor
  Future<Note?> generateNoteFromFile(File file, String fileName) async {
    try {
      Response? res;
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "${ApiConstants.baseUrl}${ApiConstants.generateNoteFromFile}"));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['fileName'] = fileName;
      var response = await request.send();
      res = await http.Response.fromStream(response);
      dynamic body = json.decode(res.body);
      ResponseModel responseModel = ResponseModel.fromJson(body);
      Note? noteModel = Note.fromJson(responseModel.data);
      return noteModel;
    } catch (e) {
      return null;
    }
  }

  Future<Note?> generateNoteFromURL(VideoModel videoModel) async {
    try {
      Response? response;
      response = await Api.instance.postRequest(ApiConstants.baseUrl,
          ApiConstants.generateNoteFromVideo, jsonEncode(videoModel.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        Note? noteModel = Note.fromJson(responseModel.data);
        return noteModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
