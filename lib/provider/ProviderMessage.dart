import 'package:dwbs_app_flutter/common/Storage.dart';
import 'package:dwbs_app_flutter/common/Ycn.dart';
import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';
import 'package:dwbs_app_flutter/apis/app.dart';

class ProviderMessage with ChangeNotifier {
  Map _message = {
    'system': [],
    'myOrder': [],
    'downOrder': [],
    'systemLOCAL': Storage.getter('SYSTEM_MESSAGE').length > 0 ? Storage.getter('SYSTEM_MESSAGE') : [],
    'myOrderLOCAL': Storage.getter('MY_ORDER_MESSAGE').length > 0 ? Storage.getter('MY_ORDER_MESSAGE') : [],
    'downOrderLOCAL': Storage.getter('DOWN_ORDER_MESSAGE').length > 0 ? Storage.getter('DOWN_ORDER_MESSAGE') : [],
  };

  // 获取未读通知总数
  int get totalMessageNum => this._message['system'].length + this._message['myOrder'].length + this._message['downOrder'].length;

  // 获取未读系统消息数量
  int get systemMessageNum => this._message['system'].length;

  // 获取所有系统消息总数量
  int get systemMessageNumTotal => this._message['system'].length + this._message['systemLOCAL'].length;

  // 获取未读我的订单消息数量
  int get myOrderMessageNum => this._message['myOrder'].length;

  // 获取未读下级订单消息数量
  int get downOrderMessageNum => this._message['downOrder'].length;

  // 获取未读订单消息总数量
  int get orderMessageNum => this._message['myOrder'].length + this._message['downOrder'].length;

  // 获取消息通知页面订单通知预览文字
  String get previewOrderMessageText {
    if (this._message['myOrder'].length > 0) {
      return '恭喜您！您有一份价值 ${this._message['myOrder'][0]['goodList'].fold(0, (t, e) => t + e['price'] * e['num'])} 元的订单${Ycn.formatOrderStatus(this._message['myOrder'][0]['status'])}！';
    } else if (this._message['downOrder'].length > 0) {
      return '恭喜您！您有 ${this._message['downOrder'].length} 份新的下级订单等待确认！';
    } else {
      return '暂无新消息';
    }
  }

  // 获取消息通知页面系统通知预览文字
  String get previewSystemMessageText {
    if (this._message['system'].length > 0) {
      return this._message['system'][0]['message'];
    } else {
      return '暂无新消息';
    }
  }

  // 获取根据日期分组我的订单消息
  Map get myOrderMessageByDate {
    final myOrder = Ycn.clone(this._message['myOrder']);
    final myOrderLOCAL = Ycn.clone(this._message['myOrderLOCAL']);
    Map orders = Map();
    final showList = [...myOrder, ...myOrderLOCAL];
    showList.forEach((orderItem) {
      orderItem['index'] = showList.indexOf(orderItem);
      final List timeArr = Ycn.formatTime(orderItem['time'], array: true);
      final String date = '${timeArr[0]}-${timeArr[1]}-${timeArr[3]}';
      orders[date] == null ? orders[date] = [orderItem] : orders[date].add(orderItem);
    });
    return orders;
  }

  // 获取根据日期分组下级订单消息
  Map get downOrderMessageByDate {
    final downOrder = Ycn.clone(this._message['downOrder']);
    final downOrderLOCAL = Ycn.clone(this._message['downOrderLOCAL']);
    Map orders = Map();
    final showList = [...downOrder, ...downOrderLOCAL];
    showList.forEach((orderItem) {
      orderItem['index'] = showList.indexOf(orderItem);
      final List timeArr = Ycn.formatTime(orderItem['time'], array: true);
      final String date = '${timeArr[0]}-${timeArr[1]}-${timeArr[3]}';
      orders[date] == null ? orders[date] = [orderItem] : orders[date].add(orderItem);
    });
    return orders;
  }

  // 获取所有的系统消息
  List get systemMessages => [...this._message['system'], ...this._message['systemLOCAL']];

  // 获取所有缓存的系统消息大小
  double get messageStorageSize {
    return [...this._message['systemLOCAL'], ...this._message['myOrderLOCAL'], ...this._message['downOrderLOCAL']].toString().length / 1024;
  }

  // 清除服务器未读的订单消息
  void clearUnreadOrderMessages(index) {
    if (index == 0) {
      this._message['myOrder'].forEach((orderItem) {
        orderItem['readed'] = false;
      });
      this._message['myOrderLOCAL'].insertAll(0, this._message['myOrder']);
      this._message['myOrder'] = [];
      Storage.setter('MY_ORDER_MESSAGE', this._message['myOrderLOCAL']);
    } else if (index == 1) {
      this._message['downOrder'].forEach((orderItem) {
        orderItem['readed'] = false;
      });
      this._message['downOrderLOCAL'].insertAll(0, this._message['downOrder']);
      this._message['downOrder'] = [];
      Storage.setter('DOWN_ORDER_MESSAGE', this._message['downOrderLOCAL']);
    }
    notifyListeners();
  }

  // 清除服务器未读的系统消息
  void clearUnreadSystemMessages() {
    this._message['systemLOCAL'].insertAll(0, this._message['system']);
    this._message['system'] = [];
    Storage.setter('SYSTEM_MESSAGE', this._message['systemLOCAL']);
    notifyListeners();
  }

  // 将单条订单消息设为已读
  void readMessage(type, index) {
    if (type == 0) {
      this._message['myOrderLOCAL'][index]['readed'] = true;
      Storage.setter('MY_ORDER_MESSAGE', this._message['myOrderLocal']);
    } else if (type == 1) {
      this._message['downOrderLOCAL'][index]['readed'] = true;
      Storage.setter('DOWN_ORDER_MESSAGE', this._message['downOrderLOCAL']);
    }
    notifyListeners();
  }

  // 从服务器获取系统通知
  Future getMessage() async {
    final res = (await apiGetMessage()).data;
    this._message['system'] = res['data']['system'];
    this._message['myOrder'] = res['data']['myOrder'];
    this._message['downOrder'] = res['data']['downOrder'];
    notifyListeners();
  }

  // 清除系统通知缓存
  void clearMessageStorage() {
    Storage.del('SYSTEM_MESSAGE');
    Storage.del('MY_ORDER_MESSAGE');
    Storage.del('DOWN_ORDER_MESSAGE');
    this._message['systemLOCAL'] = [];
    this._message['myOrderLOCAL'] = [];
    this._message['downOrderLOCAL'] = [];
    notifyListeners();
  }
}
