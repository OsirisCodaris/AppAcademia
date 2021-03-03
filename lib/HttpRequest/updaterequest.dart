import 'dart:async';
import 'dart:convert' as convert;
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/models/app_version.dart';
import 'package:dio/dio.dart';

class UpdateRequest {
  static Future<dynamic> checkUpdate() async {
    try {
      Dio dio = new Dio(Api.options);
      var response = await dio.get("/update/lastest");
      var jsonResponse = convert.jsonDecode(response.toString());
      var appversion = new AppVersion.fromJson(jsonResponse['appversion']);

      return appversion;
    } catch (e) {
      throw e;
    }
  }
}
