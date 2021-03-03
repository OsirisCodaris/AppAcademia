import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;

import 'package:academia/HttpRequest/Api.dart';
import 'package:dio/dio.dart';

class Authentification {
  static Future<dynamic> register(String name, String phone, String email,
      String password, int module, String type,
      [String city, String classes, String phone2]) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      var types = type == 'students'
          ? {
              "idclasses": module,
            }
          : {
              "idsubjects": module,
              "city": city,
              "classes": classes,
              "phone2": phone2
            };
      var user = {
        "fullname": name,
        "phone": phone,
        "email": email,
        "password": password
      };
      var formData = type == 'students'
          ? {"user": user, "student": types}
          : {"user": user, "teacher": types};
      Dio dio = new Dio(Api.options);
      var response = await dio.post("/$type", data: jsonEncode(formData));
      return response;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> authentifier(String name, String password) async {
    try {
      var user = {"fullname": name, "password": password};
      Dio dio = new Dio(Api.options);
      var response = await dio.post("/login",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(user));
      return response;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> refreshtoken(String token) async {
    try {
      var form = {"refresh_token": token};
      Dio dio = await Api().getApiClient();
      var response = await dio.post("/token",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(form));
      var jsonResponse = convert.jsonDecode(response.toString());
      return jsonResponse;
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
