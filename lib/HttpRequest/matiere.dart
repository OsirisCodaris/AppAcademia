import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../Config.dart';

Dio dio = new Dio(Config.options);

class Matieres {
  int idsubjects;
  String name;
  int countDoc;
  int countAnswer;
  Matieres(int id, String name, [this.countDoc, this.countAnswer]) {
    this.idsubjects = id;
    this.name = name;
  }
  static Future<dynamic> getMatiere() async {
    try {
      // Await the http get response, then decode the json-formatted response.
      var response = await dio.get("/subjects");

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Matieres> matieres = [];
      jsonResponse['rows'].forEach((matiere) {
        matieres.add(new Matieres(matiere['idsubjects'], matiere['name']));
      });
      return matieres;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getMatiereClasse(int idclasses) async {
    try {
      var response = await dio.get("/classes/$idclasses/subjects/stats");
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Matieres> matieres = [];
      jsonResponse['subjectHasClasses'].forEach((matiere) {
        matieres.add(new Matieres(matiere['idsubjects'], matiere['name'],
            matiere['countDocument'], matiere['countAnswer']));
      });
      return matieres;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
