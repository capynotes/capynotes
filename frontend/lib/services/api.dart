import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:capynotes/model/user/user_info_model.dart';
import 'package:http/http.dart' as http;

class Api {
  static final Api _instance = Api._init();
  static Api get instance => _instance;
  Api._init();

  Map<String, String> get tokenHeader => UserInfo.loggedUser?.token == null
      ? {"Content-Type": "application/json", "Authorization": "Bearer"}
      : {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UserInfo.loggedUser?.token}"
        };

  Future<AWSHttpResponse> getRequest(String adress, String path) async {
    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final identityToken = result.userPoolTokensResult.value.idToken.raw;

    final restOperation = Amplify.API.get(
      path,
      headers: {
        "Authorization": identityToken,
        "Content-Type": "application/json"
      },
    );
    final response = await restOperation.response;
    return response;
  }

  Future<AWSHttpResponse> postRequest(String adress, String path,
      [Object? requestBody]) async {
    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final identityToken = result.userPoolTokensResult.value.idToken.raw;

    final restOperation = Amplify.API.post(path,
        headers: {
          "Authorization": identityToken,
          "Content-Type": "application/json"
        },
        body: HttpPayload(requestBody, "application/json"));
    final response = await restOperation.response;
    return response;
  }

  Future<http.Response> loginRequest(String adress, String path,
      [Object? requestBody]) async {
    final response = await http.post(Uri.parse(adress + path),
        headers: tokenHeader, body: requestBody);

    return response;
  }

  Future<http.Response> putRequest(String adress, String path,
      [Object? requestBody]) async {
    final response = await http.put(Uri.parse(adress + path),
        headers: tokenHeader, body: requestBody);
    return response;
  }

  Future<http.Response> deleteRequest(String adress, String path,
      [Object? requestBody]) async {
    final response = await http.delete(Uri.parse(adress + path),
        headers: tokenHeader, body: requestBody);
    return response;
  }
}
