import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../Config.dart';

Dio dio = new Dio(Config.options);

class Profile {
  static Future<dynamic> update(
      int id, String name, String phone, String email, String type) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      var user = {"fullname": name, "phone": phone, "email": email};
      var formData = {"user": user};

      var response = await dio.put("/$type/$id", data: jsonEncode(formData));
      return response;
    } on DioError catch (e) {
      e.error = 500;
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> resetpassword(String email) async {
    try {
      var user = {"email": email};
      var response = await dio.post("/resetpassword",
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
