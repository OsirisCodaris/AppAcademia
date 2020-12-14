import 'package:dio/dio.dart';

class Config {
  static final BaseOptions options = new BaseOptions(
    baseUrl: "https://app.academiagabon.ga/v1",
    connectTimeout: 25000,
    receiveTimeout: 20000,
  );
}
