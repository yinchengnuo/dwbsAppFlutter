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
  @override
  Widget build(BuildContext context) {
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
                                    image: NetworkImage(
                                        'https://t8.baidu.com/it/u=3571592872,3353494284&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1582962246&t=76ddb9aebe627c4a5bebc91cba9fab84'),
                                  ),
                                ),
                                child: Container(
                                  transform: Matrix4.translationValues(Ycn.px(56), Ycn.px(49), 0),
                                  child: Image.asset('lib/images/home/my/has-shop.png', width: Ycn.px(53), height: Ycn.px(63)),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.fromLTRB(Ycn.px(0), Ycn.px(10), Ycn.px(0), Ycn.px(10)),
                                  margin: EdgeInsets.fromLTRB(Ycn.px(16), Ycn.px(0), Ycn.px(16), Ycn.px(0)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('我是谁', style: TextStyle(fontSize: Ycn.px(32))),
                                          SizedBox(width: Ycn.px(17)),
                                          UserLevel(level: '顶级代理'),
                                        ],
                                      ),
                                      Text('ID:123456789',
                                          style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.body2.color)),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: Ycn.px(191),
                                height: double.infinity,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      print('点击了个人主页');
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text('个人主页', style: TextStyle(fontSize: Ycn.px(26))),
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
                              OrderItem(onum: 20, title: '待审核', route: '/test', arguments: { 'type': 0 }),
                              OrderItem(onum: 20, title: '待收货', route: '/test', arguments: { 'type': 1 }),
                              OrderItem(onum: 20, title: '已完成', route: '/test', arguments: { 'type': 2 }),
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
                            child: InkWell(onTap: () {
                              print('点击了代理升级');
                              Navigator.of(context).pushNamed('/webview', arguments: {'url': 'https://www.baidu.com'});
                            }),
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
                  ActiveItem(img: 'lib/images/home/my/zhengbasai.png', title: '争霸赛', onTap: () => print('点击了争霸赛')),
                  ActiveItem(img: 'lib/images/home/my/shalong.png', title: '线下沙龙', onTap: () => print('点击了线下沙龙')),
                  ActiveItem(img: 'lib/images/home/my/mixun.png', title: '密训营', onTap: () => print('点击了密训营')),
                ],
              ),
            ),
            SizedBox(height: Ycn.px(10)),
            AppItem(img: 'lib/images/home/my/message.png', title: '消息通知', route: '/test', msg: 6),
            AppItem(img: 'lib/images/home/my/safe.png', title: '安全管理', route: '/test'),
            AppItem(img: 'lib/images/home/my/auth.png', title: '我的授权', route: '/test'),
            AppItem(img: 'lib/images/home/my/help.png', title: '问题帮助', route: '/test'),
            SizedBox(height: Ycn.px(10)),
            AppItem(img: 'lib/images/home/my/set.png', title: '系统设置', route: '/system-set'),
          ],
        ),
      ),
    );
  }
}
