import 'dart:ui';
import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PagePersonCard extends StatefulWidget {
  PagePersonCard({Key key}) : super(key: key);

  @override
  _PagePersonCardState createState() => _PagePersonCardState();
}

class _PagePersonCardState extends State<PagePersonCard> {
  Map _data;
  bool _self = false;
  bool _expaned = false;

  // 网络请求方法
  Future _request(data) async {
    final res = (await apiGetPsesonCard(data)).data;
    setState(() {
      this._data = res['data'];
    });
  }

  // 真实姓名加 * 隐藏
  String nameHide(name) {
    name = name.padLeft(3, '*');
    List nameArr = name.split('');
    for (int i = 0; i < nameArr.length; i++) {
      if (i > 0) {
        nameArr[i] = '*';
      }
    }
    return nameArr.join();
  }

  @override
  Widget build(BuildContext context) {
    if (this._data == null) {
      this._self = (ModalRoute.of(context).settings.arguments as Map)['self'];
      this._request({'id': (ModalRoute.of(context).settings.arguments as Map)['id']}); // 请求数据
    }
    return Scaffold(
      appBar: Ycn.appBar(context, title: '${this._self ? '我的' : '个人'}名片'),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: Ycn.px(570),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: Ycn.px(300),
                              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(this._data['avatar']), fit: BoxFit.cover)),
                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), child: Container(color: Colors.white10)),
                            ),
                            Container(
                              height: Ycn.px(270),
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(70), Ycn.px(30), Ycn.px(26)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('${this._data['nickname']}', style: TextStyle(fontSize: Ycn.px(26))),
                                  Row(
                                    children: <Widget>[
                                      Container(width: Ycn.px(298), child: Text('真实姓名：', style: TextStyle(fontSize: Ycn.px(26)))),
                                      Text(
                                        '${this._self ? this._data['real_name'] : this.nameHide(this._data['real_name'])}',
                                        style: TextStyle(fontSize: Ycn.px(26)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(width: Ycn.px(298), child: Text('联系方式：', style: TextStyle(fontSize: Ycn.px(26)))),
                                      Text('${this._data['mobile']}', style: TextStyle(fontSize: Ycn.px(26))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: Ycn.px(210),
                          left: Ycn.px(300),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Ycn.px(8)),
                            child: Image.network(this._data['avatar'], width: Ycn.px(150), height: Ycn.px(150), fit: BoxFit.fill),
                          ),
                        )
                      ],
                    ),
                  ),
                  this._expaned
                      ? Container(
                          height: Ycn.px(90),
                          color: Colors.white,
                          margin: EdgeInsets.only(top: Ycn.px(1)),
                          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                          child: Row(
                            children: <Widget>[
                              Container(width: Ycn.px(298), child: Text('代理级别', style: TextStyle(fontSize: Ycn.px(26)))),
                              Text(this._data['level'], style: TextStyle(fontSize: Ycn.px(26)))
                            ],
                          ),
                        )
                      : Container(width: 0, height: 0),
                  this._expaned
                      ? Container(
                          height: Ycn.px(90),
                          color: Colors.white,
                          margin: EdgeInsets.only(top: Ycn.px(1)),
                          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                          child: Row(
                            children: <Widget>[
                              Container(width: Ycn.px(298), child: Text('邀请人', style: TextStyle(fontSize: Ycn.px(26)))),
                              Text(this._data['recom_nickname'], style: TextStyle(fontSize: Ycn.px(26)))
                            ],
                          ),
                        )
                      : Container(width: 0, height: 0),
                  this._expaned
                      ? Container(
                          height: Ycn.px(90),
                          color: Colors.white,
                          margin: EdgeInsets.only(top: Ycn.px(1)),
                          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                          child: Row(
                            children: <Widget>[
                              Container(width: Ycn.px(298), child: Text('上级代理', style: TextStyle(fontSize: Ycn.px(26)))),
                              Text(this._data['up_nickname'], style: TextStyle(fontSize: Ycn.px(26)))
                            ],
                          ),
                        )
                      : Container(width: 0, height: 0),
                  Container(
                    height: Ycn.px(60),
                    color: Colors.white,
                    margin: EdgeInsets.only(top: Ycn.px(1)),
                    child: MaterialInkWell(
                      onTap: () => setState(() => this._expaned = !this._expaned),
                      child: Center(
                        child: Text(
                          this._expaned ? '收起' : '显示更多',
                          style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    margin: EdgeInsets.only(top: Ycn.px(10)),
                    child: MaterialInkWell(
                      onTap: () => Navigator.of(context).pushNamed('/auth-card', arguments: {
                        'id': (ModalRoute.of(context).settings.arguments as Map)['id'],
                      }),
                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text('授权书', style: TextStyle(fontSize: Ycn.px(32))), Icon(Icons.arrow_forward_ios, size: Ycn.px(30))],
                      ),
                    ),
                  ),
                  Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    margin: EdgeInsets.only(top: Ycn.px(1)),
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('团队人数', style: TextStyle(fontSize: Ycn.px(32))),
                        Text('${this._data['team_num']}人', style: TextStyle(fontSize: Ycn.px(26)))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
