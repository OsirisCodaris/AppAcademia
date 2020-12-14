import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../Config.dart';

Dio dio = new Dio(Config.options);

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

      var response = await dio.post("/$type", data: jsonEncode(formData));
      return response;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> authentifier(String name, String password) async {
    try {
      var user = {"fullname": name, "password": password};
      var response = await dio.post("/login",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(user));
      return response;
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
