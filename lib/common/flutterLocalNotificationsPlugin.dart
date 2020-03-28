import 'package:dwbs_app_flutter/common/EventBus.dart';
import 'package:dwbs_app_flutter/common/Storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  print(id);
}

Future onSelectNotification(String payload) async {
  if (payload != null) {
    print('点击了通知，参数为：${payload}');
    if (payload.split(':::')[0] == 'RELOAD_UPDATA_APK') {
      EventBus().emit('RELOAD_UPDATA_APK', payload.split(':::')[1]);
    } else if (payload == 'READ_MESSAGE') {
      print(Storage.getter('READ_MESSAGE').toString());
      if (Storage.getter('READ_MESSAGE').toString().isNotEmpty) {
        Storage.del('READ_MESSAGE');
        print(Storage.getter('READ_MESSAGE').toString());
        EventBus().emit('READ_MESSAGE');
      }
    }
  }
}
