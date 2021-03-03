import 'dart:async';
import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/classe.dart';
import 'package:dio/dio.dart';

class ClasseRequest {
  static Future<dynamic> getClasses() async {
    try {
      Dio dio = new Dio(Api.options);
      var response = await dio.get("/classes");
      var jsonResponse = convert.jsonDecode(response.toString());

      List<Classes> classes = [];
      jsonResponse['rows'].forEach((classe) {
        classes.add(new Classes.fromJson(classe));
      });
      return classes;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getClassesSubject(int idSubject) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      Dio dio = new Dio(Api.options);
      var response = await dio.get('/subjects/$idSubject/classes/stats');
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Classes> classes = [];
      jsonResponse['subjectHasClasses'].forEach((classe) {
        classes.add(new Classes.fromJson(classe));
      });
      return classes;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getForumClassesSubject(int idSubject) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      Dio dio = await Api().getApiClient();
      var response = await dio.get('/forum/subjects/$idSubject/classes/stats');
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Classes> classes = [];
      jsonResponse['subjectHasClasses'].forEach((classe) {
        classes.add(new Classes.fromJson(classe));
      });
      return classes;
    } catch (e) {
      throw e;
    }
  }
}
