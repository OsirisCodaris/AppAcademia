import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/documents.dart';

import 'package:dio/dio.dart';

class DocumentRequest {
  static Future<dynamic> getDocuments(
      int idClasse, int idMatiere, int typeDoc) async {
    try {
      Dio dio = await Api().getApiClient();
      var url =
          "/classes/${idClasse}/subjects/${idMatiere}/documents?typedocs=${typeDoc}";

      var response = await dio.get(url);

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        documents.add(Documents.fromJson(document));
      });
      return documents;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getDocumentClasseRandom(int idClasse) async {
    try {
      var url = "/classes/${idClasse}/documents/random";
      Dio dio = await Api().getApiClient();
      var response = await dio.get(url);

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        documents.add(Documents.fromJson(document));
      });
      return documents;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getDocumentSubjectRandom(int idSubject) async {
    try {
      var url = "/subjects/${idSubject}/documents/random";
      Dio dio = await Api().getApiClient();
      var response = await dio.get(url);
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        documents.add(Documents.fromJson(document));
      });
      return documents;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getDocInClasseSubject(idclasses, idsubjects) async {
    try {
      var url = "/classes/$idclasses/subjects/$idsubjects/documents";
      Dio dio = await Api().getApiClient();
      var response = await dio.get(url);

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        documents.add(Documents.fromJson(document));
      });
      return documents;
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
