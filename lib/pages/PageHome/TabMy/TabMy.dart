import 'package:dwbs_app_flutter/provider/ProviderMessage.dart';
import 'package:dwbs_app_flutter/provider/ProviderUserInfo.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

import 'componetns/AppItem.dart';
import '../../../common/Ycn.dart';
import 'componetns/OrderItem.dart';
import 'componetns/ActiveItem.dart';
import 'package:flutter/material.dart';
import '../../../common/components.dart';

class TabMy extends StatefulWidget {
  TabMy({Key key}) : super(key: key);

  @override
  _TabMyState createState() => _TabMyState();
}

class _TabMyState extends State<TabMy> {
  ProviderMessage __message;
  ProviderUserInfo __userinfo;

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, ProviderUserInfo userinfo, ProviderMessage message, Widget child) {
      this.__userinfo = userinfo;
      this.__message = message;
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: Ycn.px(511),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      height: Ycn.px(437),
                      margin: EdgeInsets.only(bottom: Ycn.px(74)),
                      decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('lib/images/home/my/bg.png'))),
                    ),
                    Container(
                      height: Ycn.px(437),
                      margin: EdgeInsets.only(bottom: Ycn.px(74)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Ycn.appBar(context, back: false, title: '我的', transparent: true),
                          Container(
                            height: Ycn.px(100),
                            padding: EdgeInsets.only(left: Ycn.px(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: Ycn.px(100),
                                  height: Ycn.px(100),
                                  alignment: Alignment(-1, -1),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(50))),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: this.__userinfo.userinfo.length == 0
                                          ? AssetImage('lib/images/public/logo.png')
                                          : NetworkImage(this.__userinfo.userinfo['avatar']),
                                    ),
                                  ),
                                  child: Container(
                                    transform: Matrix4.translationValues(Ycn.px(56), Ycn.px(49), 0),
                                    child: this.__userinfo.userinfo.length > 0 && this.__userinfo.userinfo['store']
                                        ? Image.asset('lib/images/home/my/has-shop.png', width: Ycn.px(53), height: Ycn.px(63))
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(Ycn.px(0), Ycn.px(10), Ycn.px(0), Ycn.px(10)),
                                    margin: EdgeInsets.fromLTRB(Ycn.px(16), Ycn.px(0), Ycn.px(16), Ycn.px(0)),
                                    child: this.__userinfo.userinfo.length > 0
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth: Ycn.px(234)),
                                                    child: Text(
                                                      '${this.__userinfo.userinfo['nickname']}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: Ycn.px(32), height: 1.25),
                                                    ),
                                                  ),
                                                  SizedBox(width: Ycn.px(15)),
                                                  UserLevel(level: '${this.__userinfo.userinfo['level']}'),
                                                ],
                                              ),
                                              Text(
                                                'ID:${this.__userinfo.userinfo['uuid']}',
                                                style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.body2.color),
                                              ),
                                            ],
                                          )
                                        : Text('未登录'),
                                  ),
                                ),
                                Container(
                                  width: Ycn.px(191),
                                  height: double.infinity,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).pushNamed(
                                        '/person-card',
                                        arguments: {'id': this.__userinfo.userinfo['id'], 'self': true},
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text('我的名片', style: TextStyle(fontSize: Ycn.px(26))),
                                          SizedBox(width: Ycn.px(8)),
                                          Icon(Icons.arrow_forward_ios, size: Ycn.px(24)),
                                          SizedBox(width: Ycn.px(30))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: Ycn.px(141),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: Color.fromRGBO(126, 126, 126, 0.11), width: Ycn.px(3))),
                            ),
                            child: Row(
                              children: <Widget>[
                                OrderItem(onum: 20, title: '待审核', route: '/my-order', type: 0),
                                OrderItem(onum: 20, title: '待收货', route: '/my-order', type: 1),
                                OrderItem(onum: 20, title: '已完成', route: '/my-order', type: 2),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment(0, 1),
                      padding: EdgeInsets.fromLTRB(Ycn.px(30), 0, Ycn.px(30), Ycn.px(10)),
                      child: Container(
                        height: Ycn.px(90),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset('lib/images/home/my/user-up.png'),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(onTap: () => Navigator.of(context).pushNamed('/proxy-updata')),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: Ycn.px(180),
                child: Row(
                  children: <Widget>[
                    ActiveItem(
                        img: 'lib/images/home/my/zhengbasai.png',
                        title: '争霸赛',
                        onTap: () async {
                          if (await isWeChatInstalled()) {
                            launchWeChatMiniProgram(username: "gh_ccc3d7c5cbe0");
                          } else {
                            Ycn.toast('微信未安装');
                          }
                        }),
                    ActiveItem(img: 'lib/images/home/my/shalong.png', title: '线下沙龙', onTap: () => Ycn.toast('暂未开放')),
                    ActiveItem(img: 'lib/images/home/my/mixun.png', title: '密训营', onTap: () => Ycn.toast('暂未开放')),
                  ],
                ),
              ),
              SizedBox(height: Ycn.px(10)),
              AppItem(
                  img: 'lib/images/home/my/message.png', title: '消息通知', route: '/message-notification', number: this.__message.totalMessageNum),
              AppItem(img: 'lib/images/home/my/safe.png', title: '安全管理', route: '/safe-manage'),
              AppItem(
                img: 'lib/images/home/my/auth.png',
                title: '我的授权',
                route: '/auth-card',
                arguments: {'id': this.__userinfo.userinfo['id']},
              ),
              AppItem(img: 'lib/images/home/my/help.png', title: '问题帮助', route: '/problem-help'),
              SizedBox(height: Ycn.px(10)),
              AppItem(img: 'lib/images/home/my/set.png', title: '系统设置', route: '/system-set'),
            ],
          ),
        ),
      );
    });
  }
}
