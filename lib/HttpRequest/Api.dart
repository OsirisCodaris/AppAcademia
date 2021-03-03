import 'package:academia/HttpRequest/TokenInterceptors.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/models/user.dart';
import 'package:academia/utils/url.dart';
import 'package:dio/dio.dart';

class Api {
  static final BaseOptions options = new BaseOptions(
    baseUrl: Url.BASE_URL + '/v1',
    connectTimeout: 25000,
    receiveTimeout: 20000,
  );

  Dio _dio = new Dio(options);

  Future<Dio> getApiClient() async {
    var users = await DatabaseHelper.instance.user();
    _dio.interceptors.clear();
    _dio.interceptors.add(TokenInterceptors(User.fromJson(users[0])));
    return _dio;
  }
}
