import '../common/dio.dart';

Future apiAddressGet() => dio.get('/user/show_address'); // 获取地址

Future apiAddressAdd(data) => dio.post('/user/add_address', data: data); // 新增地址

Future apiAddressDel(data) => dio.get('/user/del_address', queryParameters: data); // 删除地址

Future apiAddressUpdata(data) => dio.post('/user/update_address', data: data); // 更新地址
