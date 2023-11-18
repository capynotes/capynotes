import 'package:http/http.dart' as http;

class Api {
  static final Api _instance = Api._init();
  static Api get instance => _instance;
  Api._init();

  Map<String, String> get tokenHeader => {"Content-Type": "application/json"};

  Future<http.Response> getRequest(String adress, String path) async {
    final response =
        await http.get(Uri.parse(adress + path), headers: tokenHeader);
    return response;
  }

  Future<http.Response> postRequest(String adress, String path,
      [Object? requestBody]) async {
    final response = await http.post(Uri.parse(adress + path),
        headers: tokenHeader, body: requestBody);
    return response;
  }

  Future<http.Response> patchRequest(String adress, String path,
      [Object? requestBody]) async {
    final response = await http.patch(Uri.parse(adress + path),
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
