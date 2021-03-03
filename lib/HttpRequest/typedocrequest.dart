import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/typedocs.dart';
import 'package:dio/dio.dart';

class TypeDocRequest {
  static Future<dynamic> getTypeDoc() async {
    try {
      // Await the http get response, then decode the json-formatted response.
      Dio dio = await Api().getApiClient();
      var response = await dio.get("/typedocs");
      var jsonResponse = convert.jsonDecode(response.toString());
      List<Typedocs> typedocs = [];
      jsonResponse['rows'].forEach((typedoc) {
        typedocs.add(new Typedocs.fromJson(typedoc));
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
