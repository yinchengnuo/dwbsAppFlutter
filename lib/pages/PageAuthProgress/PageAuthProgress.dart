import 'package:dwbs_app_flutter/common/components.dart';

import '../../apis/user.dart';
import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ProviderUserInfo.dart';

class PageAuthProgress extends StatefulWidget {
  PageAuthProgress({Key key}) : super(key: key);

  @override
  _PageAuthProgressState createState() => _PageAuthProgressState();
}

class _PageAuthProgressState extends State<PageAuthProgress> {
  bool _loading = false;
  bool _requesting = false;
  ProviderUserInfo __userinfo;

  // 下拉刷新更新状态
  Future _refresh() async {
    this.__userinfo.upData((await apiUserStatus()).data['data']);
  }

  // 点击底部按钮提交
  void _submit() {
    if (num.parse(this.__userinfo.userinfo['cert_status'].toString()) == 3) {
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiComfirmAuth().then((status) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        }).whenComplete(() {
          setState(() {
            this._loading = false;
            this._requesting = false;
          });
        });
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth-identity', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderUserInfo userinfo, Widget child) {
      this.__userinfo = userinfo;
      return Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
        child: Loading(
          loading: this._loading,
          child: Scaffold(
            appBar: Ycn.appBar(context, title: '审核进度', back: false),
            body: RefreshIndicator(
              onRefresh: this._refresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: Ycn.px(200),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: Ycn.px(6), color: Ycn.getColor('#F2F2F2')))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Ycn.px(126)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.check_circle, size: Ycn.px(34), color: Theme.of(context).accentColor),
                                Expanded(
                                  child: Container(
                                      color: Theme.of(context).accentColor,
                                      height: Ycn.px(2),
                                      margin: EdgeInsets.symmetric(horizontal: Ycn.px(18))),
                                ),
                                this.__userinfo.authProgress[2]
                                    ? Icon(Icons.check_circle, size: Ycn.px(34), color: Theme.of(context).accentColor)
                                    : Icon(Icons.access_time, size: Ycn.px(34), color: Theme.of(context).textTheme.display1.color),
                                Expanded(
                                  child: Container(
                                      color: this.__userinfo.authProgress[3]
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).textTheme.display1.color,
                                      height: Ycn.px(2),
                                      margin: EdgeInsets.symmetric(horizontal: Ycn.px(18))),
                                ),
                                this.__userinfo.authProgress[4]
                                    ? Icon(Icons.check_circle, size: Ycn.px(34), color: Theme.of(context).accentColor)
                                    : Icon(Icons.access_time, size: Ycn.px(34), color: Theme.of(context).textTheme.display1.color),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Ycn.px(85)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('提交审核', style: TextStyle(fontSize: Ycn.px(30))),
                                Text('邀请人确认', style: TextStyle(fontSize: Ycn.px(30))),
                                Text('上级审核', style: TextStyle(fontSize: Ycn.px(30))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: Ycn.px(104)),
                          Image.asset('lib/images/public/auth-progress.png', width: Ycn.px(356), height: Ycn.px(356)),
                          SizedBox(height: Ycn.px(42)),
                          ...[0].map((item) {
                            if (this.__userinfo.userinfo['cert_status'].toString() == '1' ||
                                this.__userinfo.userinfo['cert_status'].toString() == '2') {
                              return Text('资料审核中...', style: TextStyle(fontSize: Ycn.px(46)));
                            } else if (this.__userinfo.userinfo['cert_status'].toString() == '3') {
                              return Text('资料审核通过', style: TextStyle(fontSize: Ycn.px(46)));
                            } else if (this.__userinfo.userinfo['cert_status'].toString() == '4') {
                              return Text('资料审核被邀请人驳回', style: TextStyle(fontSize: Ycn.px(46)));
                            } else if (this.__userinfo.userinfo['cert_status'].toString() == '5') {
                              return Text('资料审核被上级驳回', style: TextStyle(fontSize: Ycn.px(46)));
                            }
                          }).toList(),
                          SizedBox(height: Ycn.px(21)),
                          ...[0].map((item) {
                            final textColor = Theme.of(context).textTheme.body2.color;
                            if (this.__userinfo.userinfo['cert_status'].toString() == '1' ||
                                this.__userinfo.userinfo['cert_status'].toString() == '2') {
                              return Text('您的资料正在审核中，请耐心等待', style: TextStyle(fontSize: Ycn.px(32), color: textColor));
                            } else if (this.__userinfo.userinfo['cert_status'].toString() == '3') {
                              return Text('您的资料审核已通过，欢迎加入大卫博士', style: TextStyle(fontSize: Ycn.px(32), color: textColor));
                            } else if (this.__userinfo.userinfo['cert_status'].toString() == '4') {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('驳回原因：', style: TextStyle(fontSize: Ycn.px(32), color: textColor)),
                                  Text(this.__userinfo.userinfo['reject_reason'],
                                      style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                ],
                              );
                            } else if (this.__userinfo.userinfo['cert_status'].toString() == '5') {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('驳回原因：', style: TextStyle(fontSize: Ycn.px(32), color: textColor)),
                                  Text(this.__userinfo.userinfo['reject_reason'],
                                      style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                ],
                              );
                            }
                          }).toList(),
                          SizedBox(height: Ycn.px(42)),
                          num.parse(this.__userinfo.userinfo['cert_status'].toString()) > 2
                              ? Container(
                                  width: Ycn.px(630),
                                  height: Ycn.px(88),
                                  child: FlatButton(
                                    onPressed: this._submit,
                                    color: Theme.of(context).accentColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(88))),
                                    child: Text(
                                      num.parse(this.__userinfo.userinfo['cert_status'].toString()) == 3 ? '立即加入' : '重新认证',
                                      style: TextStyle(fontSize: Ycn.px(34), color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(width: 0, height: 0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
