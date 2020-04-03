import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:install_plugin/install_plugin.dart';
import '../../common/flutterLocalNotificationsPlugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'TabMy/TabMy.dart';
import '../../apis/app.dart';
import 'TabComm/TabComm.dart';
import 'TabData/TabData.dart';
import '../../apis/user.dart';
import '../../common/Ycn.dart';
import 'TabIndex/TabIndex.dart';
import '../../common/Storage.dart';
import '../../common/EventBus.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ProviderMessage.dart';
import '../../provider/ProviderUserInfo.dart';
import 'package:package_info/package_info.dart';

class PageHome extends StatefulWidget {
  PageHome({Key key}) : super(key: key);
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _activeIndex = 0;
  ProviderMessage __message;
  ProviderUserInfo __userinfo;
  PageController _pageController = PageController();
  List<Widget> _pageList = [TabIndex(), TabData(), TabComm(), TabMy()];

  final List _tabList = <Map>[
    {'title': '首页', 'icon': 'lib/images/home/tabbar/index.png', 'activeIcon': 'lib/images/home/tabbar/index-act.png'},
    {'title': '数据', 'icon': 'lib/images/home/tabbar/data.png', 'activeIcon': 'lib/images/home/tabbar/data-act.png'},
    {'title': '社区', 'icon': 'lib/images/home/tabbar/comm.png', 'activeIcon': 'lib/images/home/tabbar/comm-act.png'},
    {'title': '我的', 'icon': 'lib/images/home/tabbar/my.png', 'activeIcon': 'lib/images/home/tabbar/my-act.png'}
  ];

  // tabbar 切换
  void _switchTab(index) {
    setState(() {
      this._activeIndex = index;
      this._pageController.jumpToPage(index);
    });
  }

  // 获取用户状态并判断
  void _getUserStatus() {
    apiUserStatus().then((status) async {
      this.__userinfo.upData(status.data['data']);
      if (this.__userinfo.userinfo['status'].toString() == '1') {
        final status = num.parse(this.__userinfo.userinfo['cert_status'].toString());
        if (status == 0) {
          await Ycn.modalImg(context, 'lib/images/home/modal/auth.png', Ycn.px(575), Ycn.px(696), back: false);
          Navigator.of(context).pushNamedAndRemoveUntil('/auth-identity', (Route<dynamic> route) => false);
        } else if (status > 0 && status < 6) {
          Navigator.of(context).pushNamedAndRemoveUntil('/auth-progress', (Route<dynamic> route) => false);
        } else if (status == 6) {
          this._getUserInfo();
        }
      } else if (this.__userinfo.userinfo['status'].toString() == '0') {
        await Ycn.modal(context, content: ['该账号状态异常，登陆失败'], back: false, cancel: false);
        Storage.del('token');
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });
  }

  // 获取用户信息并判断
  void _getUserInfo() {
    this.__message.getMessage(); // 获取用户消息通知
    apiUserInfo().then((status) async {
      this.__userinfo.upData(status.data['data']);
      if (num.parse(this.__userinfo.userinfo['level_change'].toString()) == 1) {
        if (this.__userinfo.userinfo['level'] == '顶级代理') {
          await Ycn.modalImg(context, 'lib/images/home/modal/upToTop.png', Ycn.px(576), Ycn.px(676), back: false);
        } else if (this.__userinfo.userinfo['level'] == '皇冠代理') {
          await Ycn.modalImg(context, 'lib/images/home/modal/upToCrown.png', Ycn.px(576), Ycn.px(676), back: false);
        }
      } else if (num.parse(this.__userinfo.userinfo['level_change'].toString()) == -1) {
        if (this.__userinfo.userinfo['level'] == '顶级代理') {
          await Ycn.modalImg(context, 'lib/images/home/modal/downToTop.png', Ycn.px(576), Ycn.px(676), back: false);
        } else if (this.__userinfo.userinfo['level'] == '特级代理') {
          await Ycn.modalImg(context, 'lib/images/home/modal/downToSuper.png', Ycn.px(576), Ycn.px(676), back: false);
        }
      }
      apiComfirmLevel(); // 用户确认等级变动
      this._appUpdata();
    });
  }

  // app 检查更新
  void _appUpdata() {
    apiAppUpdata().then((status) async {
      if ((await PackageInfo.fromPlatform()).version != status.data['data']['version']) {
        Ycn.modalUpdata(context, status.data['data']['version'], status.data['data']['message']).then((res) async {
          if (res != null) {
            if (Platform.isAndroid) {
              if ((await PermissionHandler().requestPermissions([PermissionGroup.storage]))[PermissionGroup.storage] == PermissionStatus.granted) {
                this._downloadUpdata(status.data['data']['url']);
                Ycn.toast('新版本开始下载...');
              } else {
                Ycn.toast('更新失败，请为大卫博士开启写入存储权限');
              }
            }
          }
        });
      }
    });
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

  // 初始化被本地通知
  void _initLocalNotification() async {
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings('app_icon'),
        IOSInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        ),
      ),
      onSelectNotification: onSelectNotification,
    );
  }

  @override
  void initState() {
    super.initState();
    this._initLocalNotification(); // 初始化系统通知
    this._getUserStatus(); // 获取用户状态
    // 监听点击首页显示更多文章
    EventBus().on('SHOWMOREARTICLE', (e) {
      Storage.setter('SHOWMOREARTICLE', 'SHOWMOREARTICLE');
      this._switchTab(2);
    });
    // 监听用户点击通知栏重新下载
    EventBus().on('RELOAD_UPDATA_APK', (url) {
      this._downloadUpdata(url);
    });
    // 监听用户点击通知栏未读消息
    EventBus().on('READ_MESSAGE', (q) {
      Navigator.of(context).pushNamed('/message-notification');
    });
    // 监听 token 失效跳转
    EventBus().on('LOGIN', (arg) {
      Storage.del('token');
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('lib/images/home/tabbar/index.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/index-act.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/data.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/data-act.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/comm.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/comm-act.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/my.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/my-act.png'), context);

    return Consumer2(builder: (BuildContext context, ProviderUserInfo userinfo, ProviderMessage message, Widget child) {
      this.__message = message;
      this.__userinfo = userinfo;
      return WillPopScope(
          onWillPop: () async {
            final res = await Ycn.modal(context, content: ['确定退出大卫博士？']);
            if (res == null) {
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            body: PageView(children: this._pageList, controller: this._pageController, physics: NeverScrollableScrollPhysics()),
            bottomNavigationBar: Container(
              height: Ycn.px(97),
              decoration: BoxDecoration(border: Border(top: BorderSide(width: Ycn.px(1), color: Color.fromRGBO(178, 178, 178, 0.1)))),
              child: Row(
                children: <Widget>[
                  ...this
                      ._tabList
                      .map(
                        (item) => Expanded(
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () => this._switchTab(this._tabList.indexOf(item)),
                              child: this._tabList.indexOf(item) == 3
                                  ? Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: CustomBottomNavigationBarItem(
                                              item: item, index: this._tabList.indexOf(item), activeIndex: this._activeIndex),
                                        ),
                                        Positioned(top: Ycn.px(8), left: Ycn.px(98), child: RedDot(number: this.__message.totalMessageNum)),
                                      ],
                                    )
                                  : CustomBottomNavigationBarItem(item: item, index: this._tabList.indexOf(item), activeIndex: this._activeIndex),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ));
    });
  }
}

// 自定义底部导航栏
class CustomBottomNavigationBarItem extends StatelessWidget {
  final item, index, activeIndex;
  const CustomBottomNavigationBarItem({Key key, this.item, this.index, this.activeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        this.activeIndex == this.index
            ? ImageIcon(AssetImage(item['activeIcon']), size: Ycn.px(32), color: Theme.of(context).accentColor)
            : ImageIcon(AssetImage(item['icon']), size: Ycn.px(32), color: Theme.of(context).textTheme.body2.color),
        SizedBox(height: Ycn.px(8)),
        Text(
          item['title'],
          style: TextStyle(
            fontSize: Ycn.px(22),
            color: this.activeIndex == this.index ? Theme.of(context).accentColor : Theme.of(context).textTheme.body2.color,
          ),
        ),
      ],
    );
  }
}
