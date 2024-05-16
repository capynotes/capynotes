import 'dart:convert';
import 'package:aws_common/aws_common.dart';
import 'package:capynotes/constants/api_constants.dart';
import 'package:capynotes/model/auth/change_password_model.dart';
import 'package:capynotes/model/auth/register_model.dart';
import 'package:http/http.dart';

import '../model/auth/login_model.dart';
import '../model/base_response_model.dart';
import '../model/user/user_info_model.dart';
import '../model/user/user_model.dart';
import 'api.dart';

class AuthService {
  AuthService();
  Future<UserModel?> register(RegisterModel bodyModel) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance.postRequest(ApiConstants.baseUrl,
          ApiConstants.register, jsonEncode(bodyModel.toJson()));
      if (response.statusCode == 200) {
        dynamic body = response.decodeBody();
        ResponseModel responseModel = ResponseModel.fromJson(jsonDecode(body));
        return UserModel.fromJson(responseModel.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> login(LoginModel bodyModel) async {
    try {
      Response? response;
      response = await Api.instance.loginRequest(ApiConstants.baseUrl,
          ApiConstants.login, jsonEncode(bodyModel.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        ResponseModel responseModel = ResponseModel.fromJson(body);
        UserModel authResponseModel = UserModel.fromJson(responseModel.data);
        UserInfo.loggedUser = authResponseModel;
        UserInfo.token = authResponseModel.token;
        return authResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> changePassword(ChangePasswordModel bodyModel) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance.putRequest(ApiConstants.baseUrl,
          ApiConstants.changePw, jsonEncode(bodyModel.toJson()));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.decodeBody());
        ResponseModel responseModel = ResponseModel.fromJson(body);
        response = responseModel.data;
        return response.toString();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      AWSHttpResponse? response;
      response = await Api.instance
          .postRequest(ApiConstants.baseUrl, "${ApiConstants.forgotPw}$email");
      if (response.statusCode == 200) {
        dynamic body = response.decodeBody();
        ResponseModel responseModel = ResponseModel.fromJson(jsonDecode(body));
        response = responseModel.data;
        return response.toString();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
