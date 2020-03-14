import '../common/dio.dart';

Future apiSubmitOrder(data) => dio.post('/order/submit_order', data: data); // 提交订单

Future apiMyOrder1(data) => dio.get('/order/my_order?type=0', queryParameters: data); // 我的订单待审核列表
Future apiMyOrder2(data) => dio.get('/order/my_order?type=1', queryParameters: data); // 我的订单待收货列表
Future apiMyOrder3(data) => dio.get('/order/my_order?type=2', queryParameters: data); // 我的订单已完成列表

Future apiDownOrder1(data) => dio.get('/order/order_lower?type=0', queryParameters: data); // 下级订单待审核列表
Future apiDownOrder2(data) => dio.get('/order/order_lower?type=1', queryParameters: data); // 下级订单待发货列表
Future apiDownOrder3(data) => dio.get('/order/order_lower?type=2', queryParameters: data); // 下级订单已发货列表
Future apiDownOrder4(data) => dio.get('/order/order_turn', queryParameters: data); // 下级订单已转单列表
Future apiDownOrder5(data) => dio.get('/order/order_lower?type=3', queryParameters: data); // 下级订单已完成列表

Future apiDelOrder(data) => dio.get('/order/del', queryParameters: data); // 删除订单

Future apiReveiveMonkey(data) => dio.get('/order/order_sure_pay', queryParameters: data); // 确认收款

Future apiReveiveGoods(data) => dio.get('/order/order_complete', queryParameters: data); // 确认收货

Future apiOrderDetail(data) => dio.get('/order/detail', queryParameters: data); // 获取订单详情

Future apiMyStck() => dio.get('/order/my_storage'); // 获取我的库存

Future apiSendGood(data) => dio.post('/order/forward', data: data); // 获取我的库存
