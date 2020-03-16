import 'package:dwbs_app_flutter/common/Ycn.dart';

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
    print('拦截器');
    if (response.data['code'] == 401) {
      EventBus().emit('LOGIN');
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError error) {
    if (error.toString().indexOf('404') != -1) {
      EventBus().emit('LOGIN');
    } else {
      Ycn.toast('网络好像出了点问题...');
    }
    return super.onError(error);
  }
}
