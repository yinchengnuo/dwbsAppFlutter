import 'dart:async';

import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/provider/ProviderUserInfo.dart';
import 'package:provider/provider.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageProxyUpdata extends StatefulWidget {
  PageProxyUpdata({Key key}) : super(key: key);

  @override
  _PageProxyUpdataState createState() => _PageProxyUpdataState();
}

class _PageProxyUpdataState extends State<PageProxyUpdata> {
  Map _data;
  Timer _timer;
  ProviderUserInfo __userinfo;
  String _timeString = '';

  // 格式化距离时间
  void fromNow(long) {
    final day = long ~/ 86400000;
    final hour = (long % 86400000) ~/ 3600000;
    final minite = ((long % 86400000) % 3600000) ~/ 60000;
    final second = (((long % 86400000) % 3600000) % 60000) ~/ 1000;
    addZero(number) => number.toString().length == 1 ? '0${number}' : number;
    setState(() {
      this._timeString = '截止时间：${addZero(day)}天${addZero(hour)}时${addZero(minite)}分${addZero(second)}秒';
    });
  }

  // 请求活动状态
  void _request() {
    apiProxyUpdata().then((status) {
      setState(() {
        if (status.data['data']['status'].toString() == '1') {
          Navigator.of(context).pushReplacementNamed('/updata-status');
          return;
        } else {
          this._data = status.data['data'];
        }
      });
      if (status.data['data']['isActive']) {
        if (int.parse(status.data['data']['end']) - DateTime.now().millisecondsSinceEpoch > 1000) {
          int fromNowLong = int.parse(status.data['data']['end']) - DateTime.now().millisecondsSinceEpoch;
          this.fromNow(fromNowLong);
          Timer.periodic(Duration(seconds: 1), (timer) {
            this._timer = timer;
            fromNowLong -= 1000;
            if (fromNowLong <= 0) {
              setState(() {
                this._timeString = '活动未开始';
              });
              timer.cancel();
            } else {
              this.fromNow(fromNowLong);
            }
          });
        } else {
          setState(() {
            this._timeString = '活动未开始';
          });
        }
      } else {
        setState(() {
          this._timeString = '活动未开始';
        });
      }
    });
  }

  // 点击立即升级
  void _updata() {
    Navigator.of(context).pushNamed('/my-updata').then((res) {
      print(res);
      if (res != null) {
        Navigator.of(context).pushReplacementNamed('/updata-status');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._request();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderUserInfo userinfo, Widget child) {
      this.__userinfo = userinfo;
      return Scaffold(
        appBar: Ycn.appBar(context, title: '代理升级'),
        body: this._data == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: Ycn.px(427),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            width: Ycn.px(900),
                            left: Ycn.px(-75),
                            child: Container(
                              height: Ycn.px(269),
                              decoration: BoxDecoration(
                                color: Ycn.getColor('#E5C29E'),
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(Ycn.px(234))),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(child: Center(child: Text('专享活动折扣', style: TextStyle(fontSize: Ycn.px(40))))),
                                        Positioned(
                                          top: Ycn.px(47),
                                          right: Ycn.px(30),
                                          width: Ycn.px(140),
                                          height: Ycn.px(42),
                                          child: FlatButton(
                                            padding: EdgeInsets.all(0),
                                            color: Ycn.getColor('#CEB690'),
                                            onPressed: () => Navigator.of(context).pushNamed('/how-to-updata'),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(42))),
                                            child: Text('如何升级?', style: TextStyle(fontSize: Ycn.px(26), color: Ycn.getColor('#774F24'))),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Ycn.px(688),
                                  height: Ycn.px(302),
                                  child: Stack(
                                    children: <Widget>[
                                      this.__userinfo.userinfo['level'] == '特级代理'
                                          ? Image.asset(
                                              'lib/images/public/super-price.png',
                                              width: Ycn.px(688),
                                              height: Ycn.px(302),
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              'lib/images/public/top-price.png',
                                              width: Ycn.px(688),
                                              height: Ycn.px(302),
                                              fit: BoxFit.fill,
                                            ),
                                      Positioned(
                                        right: 0,
                                        top: Ycn.px(136),
                                        left: Ycn.px(251),
                                        bottom: Ycn.px(36),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              this.__userinfo.userinfo['level'] == '特级代理'
                                                  ? '￥${Ycn.numDot(this._data['top_money'])}'
                                                  : '￥${Ycn.numDot(this._data['crown_money'])}',
                                              style:
                                                  TextStyle(color: Ycn.getColor('#DFA757'), fontSize: Ycn.px(50), fontWeight: FontWeight.bold),
                                            ),
                                            Text(this._timeString, style: TextStyle(fontSize: Ycn.px(26), color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Ycn.px(63)),
                    Container(
                      width: Ycn.px(690),
                      height: Ycn.px(166),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset('lib/images/public/updata-card.png', width: Ycn.px(690), height: Ycn.px(166), fit: BoxFit.fill),
                          Container(
                            padding: EdgeInsets.only(left: Ycn.px(96)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: Ycn.px(413),
                                  padding: EdgeInsets.symmetric(vertical: Ycn.px(30)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('升级为顶级代理', style: TextStyle(fontSize: Ycn.px(32))),
                                      Text('活动价：￥${Ycn.numDot(this._data['top_money'])}', style: TextStyle(fontSize: Ycn.px(24))),
                                      Text(
                                        '使用期限：2020年1月1日—1月3日',
                                        style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.display1.color),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('￥${Ycn.numDot(this._data['top_money'])}'),
                                      SizedBox(height: Ycn.px(22)),
                                      Container(
                                        width: Ycn.px(126),
                                        height: Ycn.px(50),
                                        child: [0].map((e) {
                                          if (this._data['isActive']) {
                                            return this.__userinfo.userinfo['level'] == '特级代理'
                                                ? FlatButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(5))),
                                                    padding: EdgeInsets.all(0),
                                                    color: Ycn.getColor('#CEB690'),
                                                    onPressed: this._updata,
                                                    child: Text(
                                                      '立即申请',
                                                      style: TextStyle(height: 1.25, color: Colors.white, fontSize: Ycn.px(24)),
                                                    ),
                                                  )
                                                : FlatButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(5))),
                                                    padding: EdgeInsets.all(0),
                                                    color: Ycn.getColor('#999999'),
                                                    onPressed: () => Ycn.toast('您是${this.__userinfo.userinfo['level']},不可升级为顶级代理'),
                                                    child:
                                                        Text('等级不符', style: TextStyle(height: 1.25, color: Colors.white, fontSize: Ycn.px(24))),
                                                  );
                                          } else {
                                            return FlatButton(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(5))),
                                              padding: EdgeInsets.all(0),
                                              color: Ycn.getColor('#999999'),
                                              onPressed: () => Ycn.toast('活动暂未开始'),
                                              child: Text('暂未开始', style: TextStyle(height: 1.25, color: Colors.white, fontSize: Ycn.px(24))),
                                            );
                                          }
                                        }).toList()[0],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Ycn.px(27)),
                    Container(
                      width: Ycn.px(690),
                      height: Ycn.px(166),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset('lib/images/public/updata-card.png', width: Ycn.px(690), height: Ycn.px(166), fit: BoxFit.fill),
                          Container(
                            padding: EdgeInsets.only(left: Ycn.px(96)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: Ycn.px(413),
                                  padding: EdgeInsets.symmetric(vertical: Ycn.px(30)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('升级为皇冠代理', style: TextStyle(fontSize: Ycn.px(32))),
                                      Text('活动价：￥${Ycn.numDot(this._data['crown_money'])}', style: TextStyle(fontSize: Ycn.px(24))),
                                      Text('使用期限：2020年1月1日—1月3日',
                                          style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.display1.color)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('￥${Ycn.numDot(this._data['crown_money'])}'),
                                      SizedBox(height: Ycn.px(22)),
                                      Container(
                                        width: Ycn.px(126),
                                        height: Ycn.px(50),
                                        child: [0].map((e) {
                                          if (this._data['isActive']) {
                                            return this.__userinfo.userinfo['level'] == '顶级代理'
                                                ? FlatButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(5))),
                                                    padding: EdgeInsets.all(0),
                                                    color: Ycn.getColor('#CEB690'),
                                                    onPressed: this._updata,
                                                    child: Text(
                                                      '立即申请',
                                                      style: TextStyle(height: 1.25, color: Colors.white, fontSize: Ycn.px(24)),
                                                    ),
                                                  )
                                                : FlatButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(5))),
                                                    padding: EdgeInsets.all(0),
                                                    color: Ycn.getColor('#999999'),
                                                    onPressed: () => Ycn.toast('您是${this.__userinfo.userinfo['level']},不可升级为皇冠代理'),
                                                    child:
                                                        Text('等级不符', style: TextStyle(height: 1.25, color: Colors.white, fontSize: Ycn.px(24))),
                                                  );
                                          } else {
                                            return FlatButton(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(5))),
                                              padding: EdgeInsets.all(0),
                                              color: Ycn.getColor('#999999'),
                                              onPressed: () => Ycn.toast('活动暂未开始'),
                                              child: Text('暂未开始', style: TextStyle(height: 1.25, color: Colors.white, fontSize: Ycn.px(24))),
                                            );
                                          }
                                        }).toList()[0],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Ycn.px(121),
                      alignment: Alignment(0, 0),
                      child: Text('~期待更多~', style: TextStyle(fontSize: Ycn.px(24), color: Ycn.getColor('#CCCCCC'))),
                    )
                  ],
                ),
              ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._timer.cancel();
  }
}
