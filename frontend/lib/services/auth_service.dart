import 'dart:convert';
import 'package:capynotes/constants/api_constants.dart';
import 'package:capynotes/model/auth/register_model.dart';
import 'package:http/http.dart';

import '../model/auth/login_model.dart';
import 'api.dart';

class AuthService {
  AuthService();
  // Future<AuthResponseModel?> register(RegisterModel bodyModel) async {
  //   try {
  //     Response? response;
  //     response = await Api.instance.postRequest(ApiConstants.baseUrl,
  //         ApiConstants.register, jsonEncode(bodyModel.toJson()));
  //     if (response.statusCode == 201) {
  //       dynamic body = json.decode(response.body);
  //       ResponseModel responseModel = ResponseModel.fromJson(body);
  //       return AuthResponseModel.fromJson(responseModel.data);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  //}

  //Future<UserModel?> login(LoginModel bodyModel) async {
  // try {
  //   Response? response;
  //   response = await Api.instance.postRequest(ApiConstant.baseUrl,
  //       ApiConstant.login, jsonEncode(bodyModel.toJson()));
  //   if (response.statusCode == 200) {
  //     dynamic body = jsonDecode(response.body);
  //     ResponseModel responseModel = ResponseModel.fromJson(body);
  //     AuthResponseModel authResponseModel =
  //         AuthResponseModel.fromJson(responseModel.data);
  //     UserInfo.loggedUser = authResponseModel.user;
  //     UserInfo.tokens = authResponseModel.tokens;
  //     return authResponseModel.user;
  //   } else {
  //     return null;
  //   }
  // } catch (e) {
  //   return null;
  //}
}
