import '../common/dio.dart';

Future apiUserStatus() => dio.get('/user/getinfo'); // 获取用户状态
Future apiUserInfo() => dio.get('/user/per_data'); // 获取用户信息
