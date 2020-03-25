import '../common/dio.dart';

Future apiGetAuthCard(data) => dio.get('/user/auth_code', queryParameters: data); // 获取用户授权书

Future apiGetPsesonCard(data) => dio.get('/team/card_data', queryParameters: data); // 获取用户名片

Future apiGetInviteCode() => dio.get('/team/invite_code'); // 获取邀请码
Future apiTeamList1(data) => dio.get('/team/list?type=0', queryParameters: data); // 获取团队管理直属代理列表
Future apiTeamList2(data) => dio.get('/team/list?type=1', queryParameters: data); // 获取团队管理下级代理列表

Future apiTeamAchievement(data) => dio.get('/team/money', queryParameters: data); // 获取团队业绩

Future apiMyInvite1(data) => dio.get('/team/invite?type=0', queryParameters: data); // 获取我的邀请已激活列表
Future apiMyInvite2(data) => dio.get('/team/invite?type=1', queryParameters: data); // 获取我的邀请未激活列表

Future apiExamineList1(data) => dio.get('/team/examine_list?type=0', queryParameters: data); // 获取我的邀请审核列表
Future apiExamineList2(data) => dio.get('/team/examine_list?type=1', queryParameters: data); // 获取我的下级审核列表

Future apiExamine(data) => dio.get('/team/examine', queryParameters: data); // 注册审核

Future apiProxyUpdata() => dio.get('/proxy/updata'); // 获取代理升级状态
