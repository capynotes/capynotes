import 'dart:convert';

import 'package:capynotes/model/user/user_info_model.dart';
import 'package:http/http.dart';

import '../constants/api_constants.dart';
import '../model/audio_model.dart';
import '../model/base_response_model.dart';
import 'api.dart';

class AudioService {
  Future<List<AudioModel>?> getMyAudios() async {
    try {
      Response? response;
      response = await Api.instance.getRequest(ApiConstants.baseUrl,
          "${ApiConstants.getMyAudios}${UserInfo.loggedUser!.id}");
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        List<AudioModel> audioList = [];
        for (var audio in responseModel.data) {
          AudioModel audioModel = AudioModel.fromJson(audio);
          audioList.add(audioModel);
        }
        return audioList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
