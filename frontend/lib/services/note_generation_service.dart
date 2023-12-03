import 'dart:convert';

import 'package:capynotes/constants/api_constants.dart';
import 'package:capynotes/model/base_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:http/http.dart';

import '../model/audio_model.dart';

class NoteGenerationService {
  //TODO: refactor
  Future<AudioModel?> generateNote(File file, String fileName) async {
    try {
      Response? res;
      var request = http.MultipartRequest('POST',
          Uri.parse("${ApiConstants.baseUrl}${ApiConstants.generateNote}"));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['fileName'] = fileName;
      var response = await request.send();
      res = await http.Response.fromStream(response);
      dynamic body = json.decode(res.body);
      ResponseModel responseModel = ResponseModel.fromJson(body);
      AudioModel? audioModel = AudioModel.fromJson(responseModel.data);
      return audioModel;
    } catch (e) {
      return null;
    }
  }
}
