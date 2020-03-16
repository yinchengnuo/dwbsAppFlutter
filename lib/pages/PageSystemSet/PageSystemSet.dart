import 'package:dwbs_app_flutter/apis/app.dart';
import 'package:dwbs_app_flutter/provider/ProviderMessage.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/common/Storage.dart';
import 'package:dwbs_app_flutter/common/components.dart';

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
    Ycn.modal(context, content: ['确定清除缓存的消息通知？']).then((res) {
      if (res != null) {
        this.__message.clearMessageStorage();
        Ycn.toast('清除成功');
      }
    });
  }

  // 点击检查更新
  void _checkUpdata() {
    setState(() {
      this._loading = true;
    });
    apiAppUpdata().then((status) async {
      if ((await PackageInfo.fromPlatform()).version != status.data['data']['version']) {
        setState(() {
          this._loading = false;
        });
        Ycn.modalUpdata(context, status.data['data']['version'], status.data['data']['message']).then((res) {
          if (res != null) {
            print(status.data['data']['url']);
            Ycn.toast('新版本开始下载...');
          }
        });
      } else {
        Ycn.toast('当前已是最新版本');
      }
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
                        Text(this.__message.messageStorageSize),
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
