import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/response.dart';
import 'package:dio/dio.dart';

class ResponseRequest {
  static Future<dynamic> getResponses(int idResponse) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      Dio dio = await Api().getApiClient();
      var response = await dio.get('/problems/$idResponse/responses');
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Responses> responses = [];
      jsonResponse['rows'].forEach((response) {
        responses.add(new Responses.fromJson(response));
      });
      return responses;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> sendResponse(
      int idproblems, String content, MultipartFile file) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      Dio dio = await Api().getApiClient();
      FormData formData = FormData.fromMap({
        "content": content.isEmpty ? null : content,
        "file": file,
      });
      var response =
          await dio.post('/problems/$idproblems/responses', data: formData);
      var jsonResponse = convert.jsonDecode(response.toString());
      return jsonResponse;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> changeState(int idresponses, bool value) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      print(value);
      Dio dio = await Api().getApiClient();
      var formData = {"status": value};
      var response = await dio.put('/responses/$idresponses/solved',
          data: jsonEncode(formData));
      var jsonResponse = convert.jsonDecode(response.toString());
      return jsonResponse;
    } catch (e) {
      throw e;
    }
  }
}
