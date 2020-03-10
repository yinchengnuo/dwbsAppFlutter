import '../common/dio.dart';

Future apiUserStatus() => dio.get('/user/getinfo'); // 获取用户状态

Future apiUserInfo() => dio.get('/user/per_data'); // 获取用户信息

Future apiSubmitAuth(data) => dio.get('/user/submit_user', queryParameters: data); // 用户提交认证审核

Future apiComfirmAuth() => dio.get('/user/user_cert'); // 用户确认审核通过

Future apiComfirmLevel() => dio.get('/user/confirm_level'); // 用户确认等级变动
