import '../common/dio.dart';

Future apiGetPhoneCode(data) => dio.get('/login/judge_login', queryParameters: data); // 获取手机验证码接口
Future apiLoginByCode(data) => dio.get('/login/login', queryParameters: data); // 手机号验证码登陆
Future apiReg(data) => dio.get('/login/register', queryParameters: data); // 手机号注册

Future apiWxlogin(data) => dio.get('/login/wechat_login', queryParameters: data); // 微信登陆
