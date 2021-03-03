import 'dart:async';
import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:dio/dio.dart';

class NotificationRequest {
  static Future<dynamic> haveNotif(idusers, idproblems) async {
    try {
      Dio dio = await Api().getApiClient();
      var response =
          await dio.get("/users/$idusers/problems/$idproblems/notifications");
      var jsonResponse = convert.jsonDecode(response.toString());

      return jsonResponse;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> associate(idproblems, tokenfcm) async {
    try {
      Dio dio = await Api().getApiClient();
      Map<String, String> token = {'tokenfcm': tokenfcm};
      var response = await dio.post("/problems/$idproblems/notifications",
          data: convert.jsonEncode(token));
      var jsonResponse = convert.jsonDecode(response.toString());

      return jsonResponse;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> updateTokenFcm(tokenfcm) async {
    try {
      Dio dio = await Api().getApiClient();
      var response = await dio.put("/notifications",
          data: convert.jsonEncode({'tokenfcm': tokenfcm}));
      var jsonResponse = convert.jsonDecode(response.toString());

      return jsonResponse;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> destroy() async {
    try {
      Dio dio = await Api().getApiClient();
      await dio.delete("/notifications");
    } catch (e) {
      /*impossible de delete */
    }
  }
}
