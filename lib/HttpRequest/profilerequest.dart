import 'dart:convert';
import 'dart:io';

import 'package:academia/HttpRequest/Api.dart';
import 'package:dio/dio.dart';

class Profile {
  static Future<dynamic> update(
      int id, String name, String phone, String email, String type) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      var user = {"fullname": name, "phone": phone, "email": email};
      var formData = {"user": user};
      Dio dio = await Api().getApiClient();
      var response = await dio.put("/$type/$id", data: jsonEncode(formData));

      return response;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> resetpassword(String email) async {
    try {
      var user = {"email": email};
      Dio dio = new Dio(Api.options);
      var response = await dio.post("/resetpassword",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(user));
      return response;
    } catch (e) {
      throw e;
    }
  }
}
