import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/matiere.dart';
import 'package:dio/dio.dart';

class MatiereRequest {
  static Future<dynamic> getMatiere() async {
    try {
      Dio dio = new Dio(Api.options);
      // Await the http get response, then decode the json-formatted response.
      var response = await dio.get("/subjects");

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Matieres> matieres = [];
      jsonResponse['rows'].forEach((matiere) {
        matieres.add(new Matieres.fromJson(matiere));
      });

      return matieres;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getMatiereClasse(int idclasses) async {
    try {
      Dio dio = new Dio(Api.options);
      var response = await dio.get("/classes/$idclasses/subjects/stats");
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Matieres> matieres = [];
      jsonResponse['subjectHasClasses'].forEach((matiere) {
        matieres.add(new Matieres.fromJson(matiere));
      });
      return matieres;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getForumMatiereClasse(int idclasses) async {
    try {
      Dio dio = await Api().getApiClient();
      var response = await dio.get("/forum/classes/$idclasses/subjects/stats");
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Matieres> matieres = [];
      jsonResponse['subjectHasClasses'].forEach((matiere) {
        matieres.add(new Matieres.fromJson(matiere));
      });
      return matieres;
    } catch (e) {
      throw e;
    }
  }
}
