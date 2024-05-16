import 'dart:convert';

import 'package:aws_common/aws_common.dart';
import 'package:http/http.dart';

import '../constants/api_constants.dart';
import '../model/base_response_model.dart';
import '../model/flashcard/add_flashcard_model.dart';
import '../model/flashcard/flashcard_model.dart';
import '../model/flashcard/flashcard_set_model.dart';
import 'api.dart';

class FlashcardService {
  Future<FlashcardModel?> addFlashcard(AddFlashcardModel requestBody) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance.postRequest(ApiConstants.baseUrl,
          ApiConstants.addFlashcard, jsonEncode(requestBody.toJson()));
      if (response.statusCode == 200) {
        dynamic body = response.decodeBody();
        ResponseModel responseModel = ResponseModel.fromJson(jsonDecode(body));
        FlashcardModel flashcardModel =
            FlashcardModel.fromJson(responseModel.data);
        return flashcardModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteFlashcard(int flashcardID) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance.deleteRequest(
          ApiConstants.baseUrl, "${ApiConstants.flashcard}$flashcardID");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<FlashcardModel?> editFlashcard(FlashcardModel flashcardModel) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance.putRequest(ApiConstants.baseUrl,
          ApiConstants.editFlashcard, jsonEncode(flashcardModel.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.decodeBody());
        ResponseModel responseModel = ResponseModel.fromJson(body);
        FlashcardModel flashcardModel =
            FlashcardModel.fromJson(responseModel.data);
        return flashcardModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<FlashcardSetModel?> getFlashcardSet(int setID) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance.getRequest(
        ApiConstants.baseUrl,
        "${ApiConstants.getFlashcardSet}$setID",
      );
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.decodeBody());
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
