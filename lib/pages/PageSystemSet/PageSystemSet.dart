import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dwbs_app_flutter/apis/app.dart';
import 'package:dwbs_app_flutter/common/EventBus.dart';
import 'package:dwbs_app_flutter/common/flutterLocalNotificationsPlugin.dart';
import 'package:dwbs_app_flutter/provider/ProviderMessage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/common/Storage.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import '../../common/Storage.dart';

class PageSystemSet extends StatefulWidget {
  PageSystemSet({Key key}) : super(key: key);

  @override
  _PageSystemSetState createState() => _PageSystemSetState();
}

class _PageSystemSetState extends State<PageSystemSet> {
  bool _loading = false;
  ProviderMessage __message;

  // 点击退出登陆
  void _logout() async {
    await Storage.del('token');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  // 点击清除缓存
  void _clearStorage(context) {
    Ycn.modal(context, content: ['确定清除缓存的文字和图片？']).then((res) {
      if (res != null) {
        this.__message.clearMessageStorage(); // 清除消息通知缓存
        Storage.del('AD'); // 清除闪屏图片缓存
        Ycn.toast('清除成功');
      }
    });
  }

  // 点击检查更新
  void _checkUpdata() {
    if (EventBus().globalData['updataProgress'] == 100) {
      setState(() {
        this._loading = true;
      });
      apiAppUpdata().then((status) async {
        if ((await PackageInfo.fromPlatform()).version != status.data['data']['version']) {
          setState(() {
            this._loading = false;
          });
          Ycn.modalUpdata(context, status.data['data']['version'], status.data['data']['message']).then((res) async {
            if (res != null) {
              if (Platform.isAndroid) {
                if ((await PermissionHandler().requestPermissions([PermissionGroup.storage]))[PermissionGroup.storage] ==
                    PermissionStatus.granted) {
                  this._downloadUpdata(status.data['data']['url']);
                  Ycn.toast('新版本开始下载...');
                } else {
                  Ycn.toast('更新失败，请为大卫博士开启写入存储权限');
                }
              }
            }
          });
        } else {
          Ycn.toast('当前已是最新版本');
        }
      });
    } else {
      Ycn.toast('APP更新包正在下载中 ${EventBus().globalData['updataProgress']}%');
    }
  }

  // 下载新版安装包
  void _downloadUpdata(url) async {
    int progress = 0;
    String path = '${(await getExternalStorageDirectory()).path}/new.apk';
    Dio().download(
      url,
      path,
      onReceiveProgress: (int receive, int total) async {
        if ((receive / total * 100).floor() > progress) {
          progress = (receive / total * 100).floor();
          EventBus().globalData['updataProgress'] = progress;
          await flutterLocalNotificationsPlugin.show(
            0,
            progress == 100 ? '更新包下载成功' : '更新包下载中',
            '$progress%',
            NotificationDetails(
              AndroidNotificationDetails(
                'progress channel',
                'progress channel',
                'progress channel description',
                channelShowBadge: false,
                importance: Importance.Max,
                priority: Priority.High,
                onlyAlertOnce: true,
                autoCancel: progress == 100,
                showProgress: true,
                maxProgress: 100,
                progress: progress,
              ),
              IOSNotificationDetails(),
            ),
            payload: '',
          );
          if (progress == 100) {
            InstallPlugin.installApk(path, 'com.UNI00FF211');
            await flutterLocalNotificationsPlugin.cancel(0);
          }
        }
      },
    ).catchError((e) async {
      await flutterLocalNotificationsPlugin.show(
        0,
        '更新包下载失败',
        '点击重试',
        NotificationDetails(
          AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            'progress channel description',
            channelShowBadge: false,
            importance: Importance.Max,
            priority: Priority.High,
            onlyAlertOnce: true,
            autoCancel: false,
            showProgress: true,
            maxProgress: 100,
            progress: progress,
          ),
          IOSNotificationDetails(),
        ),
        payload: 'RELOAD_UPDATA_APK:::$url',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderMessage message, Widget child) {
      this.__message = message;
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '系统设置'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                child: MaterialInkWell(
                  onTap: () => Navigator.of(context).pushNamed('/problem-feedback'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('问题反馈', style: TextStyle(fontSize: Ycn.px(32))),
                        Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Ycn.getColor('#B7B7B7'))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                child: MaterialInkWell(
                  onTap: () => Navigator.of(context).pushNamed('/app-rules'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('用户协议', style: TextStyle(fontSize: Ycn.px(32))),
                        Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Ycn.getColor('#B7B7B7'))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                child: MaterialInkWell(
                  onTap: () => this._clearStorage(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('清除缓存', style: TextStyle(fontSize: Ycn.px(32))),
                        Text('${(this.__message.messageStorageSize + Storage.getter('AD').length / 1024).floor()}KB'),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(10)),
                child: MaterialInkWell(
                  onTap: this._checkUpdata,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('检查更新', style: TextStyle(fontSize: Ycn.px(32))),
                        Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Ycn.getColor('#B7B7B7'))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                child: MaterialInkWell(
                  onTap: () => Navigator.of(context).pushNamed('/about-us'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('关于我们', style: TextStyle(fontSize: Ycn.px(32))),
                        Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Ycn.getColor('#B7B7B7'))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Ycn.px(76)),
                width: Ycn.px(630),
                height: Ycn.px(88),
                child: FlatButton(
                  onPressed: this._logout,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                  child: Text('退出登录', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
