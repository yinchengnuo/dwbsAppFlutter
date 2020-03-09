import '../common/dio.dart';

Future apiGetPhoneCode(data) => dio.get('/login/judge_login', queryParameters: data); // 获取手机验证码接口
Future apiLoginByCode(data) => dio.get('/login/login', queryParameters: data); // 手机号验证码登陆
