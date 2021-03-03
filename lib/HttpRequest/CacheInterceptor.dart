import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  var _cache = new Map<Uri, Response>();

  @override
  onRequest(RequestOptions options) async {
    return options;
  }

  @override
  onResponse(Response response) {
    _cache[response.request.uri] = response;
  }

  @override
  onError(DioError e) async {
    print('onError: $e');
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.DEFAULT) {
      var cachedResponse = _cache[e.request.uri];
      if (cachedResponse != null) {
        return cachedResponse;
      }
    }
    return e;
  }
}
