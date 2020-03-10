import '../common/dio.dart';

Future apiAppIndex() => dio.get('/app/index'); // 首页

Future apiAppData() => dio.get('/app/data'); // 数据

Future apiAppOrderChart(data) => dio.get('/app/chart?type=0', queryParameters: data); // 订单图表
Future apiAppTeamChart(data) => dio.get('/app/chart?type=1', queryParameters: data); // 团队图表
Future apiAppFortuneChart(data) => dio.get('/app/chart?type=2', queryParameters: data); // 财富图表

Future apiAppUpdata() => dio.get('/app/updata'); // app 检车更新
