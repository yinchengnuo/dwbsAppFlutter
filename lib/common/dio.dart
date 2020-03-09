import 'Storage.dart';
import 'package:dio/dio.dart';
import '../common/EventBus.dart';

Dio dio = Dio();

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    options.headers['Authorization'] = 'Bearer ' + Storage.getter('token');
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print('拦截器 worked');
    if (response.data['code'] == 401) {
      EventBus().emit('LOGIN');
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError error) {
    if (error.toString().indexOf('404') != -1) {
      EventBus().emit('LOGIN');
    }
    return super.onError(error);
  }
}
