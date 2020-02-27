import 'package:dio/dio.dart';
import '../common/EventBus.dart';

Dio dio = Dio();

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    options.headers['Authorization'] = 'Bearer ' + 'tokentokentokentokentokentoken';
    return super.onRequest(options);
  }
  @override
  Future onResponse(Response response) {
    print('拦截器 worked');
    return super.onResponse(response);
  }
  @override
  Future onError(DioError error) {
    if (error.toString().indexOf('404') != -1) {
      // 当服务器返回 404
      EventBus().emit('RequestError');
    }
    return super.onError(error);
  }
}
