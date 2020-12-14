import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../Config.dart';

Dio dio = new Dio(Config.options);

class TypeDocs {
  int idtypedocs;
  String name;
  TypeDocs(int id, String name) {
    this.idtypedocs = id;
    this.name = name;
  }
  static Future<dynamic> getTypeDoc() async {
    try {
      // Await the http get response, then decode the json-formatted response.
      var response = await dio.get("/typedocs");
      var jsonResponse = convert.jsonDecode(response.toString());
      List<TypeDocs> typedocs = [];
      jsonResponse['rows'].forEach((typedoc) {
        typedocs.add(new TypeDocs(typedoc['idtypedocs'], typedoc['name']));
      });
      return typedocs;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
