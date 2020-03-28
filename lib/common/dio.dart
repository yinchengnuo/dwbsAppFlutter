import 'package:dwbs_app_flutter/common/Ycn.dart';

import 'Storage.dart';
import 'package:dio/dio.dart';
import '../common/EventBus.dart';

Dio dio = Dio();

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    options.headers['Authorization'] = 'Bearer ' + Storage.getter('token');
    print('->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->');
    print(options.uri);
    print(options.headers);
    print(options.queryParameters == null ? options.data : options.queryParameters);
    print('=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>');
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print('<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-');
    print(response.request.uri);
    print(response.data);
    print('<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=');
    return super.onResponse(response);
  }

  @override
  Future onError(DioError error) {
    Ycn.toast('网络好像出了点问题...');
    print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    print(error.response.data);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    if (error.toString().indexOf('401') != -1) {
      EventBus().emit('LOGIN');
    }
    return super.onError(error);
  }
}
