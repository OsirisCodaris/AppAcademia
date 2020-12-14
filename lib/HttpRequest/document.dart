import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

import '../Config.dart';

Dio dio = new Dio(Config.options);

class Documents {
  int idDocument;
  String nomDocument;
  int yearPub;
  bool statut;
  String path;
  String pathAnswer;
  String notions;

  Documents(int idDocument, String nomDocument, int yearPub, bool statut,
      String path, String pathAnswer, String notions) {
    this.idDocument = idDocument;
    this.nomDocument = nomDocument;
    this.yearPub = yearPub;
    this.statut = statut;
    this.path = path;
    this.pathAnswer = pathAnswer;
    this.notions = notions;
  }

  static Future<dynamic> getDocuments(
      int idClasse, int idMatiere, int typeDoc) async {
    try {
      var url =
          "/classes/${idClasse}/subjects/${idMatiere}/documents?typedocs=${typeDoc}";

      var response = await dio.get(url);

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        if (document['docAnswer'] == null) {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                document["Notion"]["notions"]));
          }
        } else {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                document["Notion"]["notions"]));
          }
        }
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

      var response = await dio.get(url);

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        if (document['docAnswer'] == null) {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                document["Notion"]["notions"]));
          }
        } else {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                document["Notion"]["notions"]));
          }
        }
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

      var response = await dio.get(url);
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        if (document['docAnswer'] == null) {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                document["Notion"]["notions"]));
          }
        } else {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                document["Notion"]["notions"]));
          }
        }
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

      var response = await dio.get(url);

      var jsonResponse = convert.jsonDecode(response.toString());
      List<Documents> documents = [];
      jsonResponse['docInClasseSubject'].forEach((document) {
        if (document['docAnswer'] == null) {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                null,
                document["Notion"]["notions"]));
          }
        } else {
          if (document["Notion"] == null) {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                "Non renseigné"));
          } else {
            documents.add(Documents(
                document["iddocuments"],
                document["name"],
                document["year"],
                document["status"],
                document["pathfile"],
                document['docAnswer']['pathfile'],
                document["Notion"]["notions"]));
          }
        }
      });
      return documents;
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
