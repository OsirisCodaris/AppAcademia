import 'dart:async';

import 'package:academia/HttpRequest/authrequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/models/user.dart';
import 'package:academia/utils/multipartfile.dart';
import 'package:dio/dio.dart';

class TokenInterceptors extends Interceptor {
  static final BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.4.75:1999/v1",
    connectTimeout: 25000,
    receiveTimeout: 20000,
  );
  User user;
  Dio _dio = new Dio(options);

  TokenInterceptors(this.user);
  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    var token = user.token;
    options.headers["Authorization"] = "Bearer " + token;
    return options;
  }

  @override
  Future<dynamic> onError(DioError error) async {
    var token = user.token;
    var refreshToken = user.refreshToken;
    if (error.response?.statusCode == 401) {
      _dio.interceptors.requestLock.lock();
      _dio.interceptors.responseLock.lock();
      RequestOptions options = error.response.request;
      print(refreshToken);
      var response = await Authentification.refreshtoken(refreshToken);

      token = response['token'] as String;
      refreshToken = response['refreshToken'] as String;
      print('interceptor' + refreshToken);
      user.token = token;
      user.refreshToken = refreshToken;
      await DatabaseHelper.instance.updateUser(user);

      options.headers["Authorization"] = "Bearer " + token;
      _dio.interceptors.requestLock.unlock();
      _dio.interceptors.responseLock.unlock();
      if (options.data is FormData) {
        // https://github.com/flutterchina/dio/issues/482
        FormData formData = FormData();
        formData.fields.addAll(options.data.fields);
        for (MapEntry mapFile in options.data.files) {
          formData.files.add(MapEntry(
              mapFile.key,
              MultipartFileExtended.fromFileSync(mapFile.value.filePath,
                  filename: mapFile.value.filename)));
        }
        options.data = formData;
      }
      return _dio.request(options.path, options: options);
    }
    return error;
  }

  @override
  Future<dynamic> onResponse(Response response) async {
    return response;
  }
}
