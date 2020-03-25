import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:flutter/services.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageInviteProxy extends StatefulWidget {
  PageInviteProxy({Key key}) : super(key: key);

  @override
  _PageInviteProxyState createState() => _PageInviteProxyState();
}

class _PageInviteProxyState extends State<PageInviteProxy> {
  Map _data;

  void _copy() {
    Clipboard.setData(ClipboardData(text: this._data['invite_code']));
    Ycn.toast('复制成功');
  }

  @override
  void initState() {
    super.initState();
    apiGetInviteCode().then((status) {
      setState(() {
        this._data = status.data['data'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '邀请代理'),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: Ycn.px(835),
                    child: Stack(
                      children: <Widget>[
                        Image.asset('lib/images/public/invite-proxy.png', width: Ycn.px(750), height: Ycn.px(836)),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: Ycn.px(383),
                          child: Container(alignment: Alignment(0, 0), child: Text('我的邀请码', style: TextStyle(fontSize: Ycn.px(27)))),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: Ycn.px(455),
                          child: Container(
                              alignment: Alignment(0, 0),
                              child: Text('${this._data['invite_code']}', style: TextStyle(letterSpacing: Ycn.px(4), fontSize: Ycn.px(41)))),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: Ycn.px(536),
                          child: Container(
                            alignment: Alignment(0, 0),
                            child: Container(
                              width: Ycn.px(94.6),
                              height: Ycn.px(36.8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Ycn.px(36.8)),
                                border: Border.all(width: Ycn.px(1), color: Theme.of(context).accentColor),
                              ),
                              child: FlatButton(
                                onPressed: this._copy,
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(36.8))),
                                child: Text('复制', style: TextStyle(fontSize: Ycn.px(22), color: Theme.of(context).accentColor)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Ycn.px(108)),
                  Container(
                    width: Ycn.px(690),
                    height: Ycn.px(230),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text('${this._data['invite_num']}',
                                        style: TextStyle(fontSize: Ycn.px(70), color: Theme.of(context).accentColor)),
                                    Text('人', style: TextStyle(fontSize: Ycn.px(32), height: 2)),
                                  ],
                                ),
                                SizedBox(height: Ycn.px(24)),
                                Text('我的邀请', style: TextStyle(fontSize: Ycn.px(32))),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: Ycn.px(1)),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text('${this._data['team_num']}',
                                        style: TextStyle(fontSize: Ycn.px(70), color: Theme.of(context).accentColor)),
                                    Text('人', style: TextStyle(fontSize: Ycn.px(32), height: 2)),
                                  ],
                                ),
                                SizedBox(height: Ycn.px(24)),
                                Text('我的团队', style: TextStyle(fontSize: Ycn.px(32))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
