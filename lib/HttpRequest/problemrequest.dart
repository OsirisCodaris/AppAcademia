import 'dart:async';
import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/problems.dart';
import 'package:dio/dio.dart';

class ProblemRequest {
  static Future<dynamic> getProblem(int idclasses, int idsubjects) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      Dio dio = await Api().getApiClient();
      var response =
          await dio.get('/classes/$idclasses/subjects/$idsubjects/problems');
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Problems> classes = [];
      jsonResponse['rows'].forEach((classe) {
        classes.add(new Problems.fromJson(classe));
      });
      return classes;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> sendProblem(int idclasses, int idsubjects,
      String content, MultipartFile file, String filename) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      Dio dio = await Api().getApiClient();
      FormData formData = FormData.fromMap({
        "idsubjects": idsubjects,
        "content": content,
        "file": file,
      });
      var response = await dio.post('/problems', data: formData);
      var jsonResponse = convert.jsonDecode(response.toString());
      return jsonResponse;
    } catch (e) {
      throw e;
    }
  }
}
