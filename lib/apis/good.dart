import '../common/dio.dart';

Future apiGoodList() => dio.get('/goods/list'); // 获取商品列表
Future apiGoodDetail(data) => dio.get('/goods/detail', queryParameters: data); // 获取商品详情

