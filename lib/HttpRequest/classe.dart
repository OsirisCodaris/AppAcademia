import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../Config.dart';

Dio dio = new Dio(Config.options);

class Classes {
  int idclasses;
  String name;
  int countDoc;
  int countAnswer;
  Classes(int id, String name, [this.countDoc, this.countAnswer]) {
    this.idclasses = id;
    this.name = name;
  }
  static Future<dynamic> getClasses() async {
    try {
      var response = await dio.get("/classes");
      var jsonResponse = convert.jsonDecode(response.toString());

      List<Classes> classes = [];
      jsonResponse['rows'].forEach((classe) {
        classes.add(new Classes(classe['idclasses'], classe['name']));
      });
      return classes;
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getClassesSubject(int idSubject) async {
    // Await the http get response, then decode the json-formatted response.
    try {
      var response = await dio.get('/subjects/$idSubject/classes/stats');
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Classes> classes = [];
      jsonResponse['subjectHasClasses'].forEach((classe) {
        classes.add(new Classes(classe['idclasses'], classe['name'],
            classe['countDocument'], classe['countAnswer']));
      });
      return classes;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() => {"display": name, "value": name};
}
