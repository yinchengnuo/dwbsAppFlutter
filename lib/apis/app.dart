import '../common/dio.dart';

Future apiAppIndex() => dio.get('/app/index'); // 首页

Future apiAppData() => dio.get('/app/data'); // 数据

Future apiAppOrderChart(data) => dio.get('/app/chart?type=0', queryParameters: data); // 订单图表
Future apiAppTeamChart(data) => dio.get('/app/chart?type=1', queryParameters: data); // 团队图表
Future apiAppFortuneChart(data) => dio.get('/app/chart?type=2', queryParameters: data); // 财富图表

Future apiAppUpdata() => dio.get('/app/updata'); // app 检查更新

Future apiFeedback(data) => dio.get('/app/feedback', queryParameters: data); // app 问题反馈

Future apiGetMessage() => dio.get('/app/message'); // app 消息通知

Future apiReadMessage(data) => dio.get('/app/message_read', queryParameters: data); // app 消息已读
