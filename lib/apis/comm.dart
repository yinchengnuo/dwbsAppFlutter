import '../common/dio.dart';

Future apiCommListRemen(data) => dio.get('/article/show_list?type=0', queryParameters: data);
Future apiCommListZuixin(data) => dio.get('/article/show_list?type=1', queryParameters: data);
Future apiCommListChanglai(data) => dio.get('/article/show_list?type=2', queryParameters: data);
Future apiCommListShoucang(data) => dio.get('/article/mycollection', queryParameters: data);

Future apiCommListItemAction(data) => dio.get('/article/like', queryParameters: data);
