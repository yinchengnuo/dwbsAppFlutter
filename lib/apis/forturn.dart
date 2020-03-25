import '../common/dio.dart';

Future apiIncomeRunningList(data) => dio.get('/income/income', queryParameters: data); // 获取收入流水数据

Future apiRewardDetail(data) => dio.get('/income/detail', queryParameters: data); // 获取奖励收入/支出详情

Future apiRecordOrder(data) => dio.get('/inventory/record', queryParameters: data); // 零售录单

Future apiRecordOrderRecord(data) => dio.get('/inventory/record_his', queryParameters: data); // 获取零售录单历史记录
