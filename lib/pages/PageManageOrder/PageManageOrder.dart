import 'package:dwbs_app_flutter/pages/PageHome/TabIndex/components/IndexKingkongItem.dart';

import '../../apis/app.dart';
import '../../common/Ycn.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';

class PageManageOrder extends StatefulWidget {
  PageManageOrder({Key key}) : super(key: key);

  @override
  _PageManageOrderState createState() => _PageManageOrderState();
}

class _PageManageOrderState extends State<PageManageOrder> {
  Map _data; // 图表数据
  double _day = 15; // 默认天数
  List _dayList = [7, 15, 30]; // 可选择天数
  final _lineColor = Ycn.getColor('#078EC6'); // 图表内容颜色
  final _backgroundColor = Ycn.getColor('#E4F4FA'); // 图表背景颜色

  // 切换天数方法
  void _switch(item) {
    setState(() {
      this._day = item;
      this._data = null;
    });
    this._request();
  }

  // 网路请求方法
  Future _request() async {
    final res = (await apiAppOrderChart({'day': this._day.toString()})).data;
    setState(() {
      this._data = res['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    this._request(); // 发送网络请求
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '订货管理'),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: Ycn.px(720),
                color: this._backgroundColor,
                padding: EdgeInsets.fromLTRB(Ycn.px(30), 0, Ycn.px(30), 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ...this
                              ._dayList
                              .map(
                                (item) => Container(
                                  width: Ycn.px(100),
                                  height: Ycn.px(46),
                                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: Ycn.px(28)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Ycn.px(46)),
                                    border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                                  ),
                                  child: Material(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    borderRadius: BorderRadius.circular(Ycn.px(46)),
                                    color: this._day == item ? Theme.of(context).accentColor : Colors.transparent,
                                    child: InkWell(
                                      onTap: () => this._switch(item + 0.0),
                                      child: Center(
                                        child: Text(
                                          '$item天',
                                          style: TextStyle(
                                            fontSize: Ycn.px(28),
                                            color: this._day == item ? Colors.white : Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    Container(
                      height: Ycn.px(572),
                      child: MyLineChart(
                        data: this._data,
                        lineColor: this._lineColor,
                        backgroundColor: this._backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Ycn.px(10)),
              Wrap(
                children: <Widget>[
                  IndexKingkongItem(src: 'lib/images/home/index/place-order.png', title: '订货下单', route: '/good-list'),
                  IndexKingkongItem(src: 'lib/images/home/index/my-order.png', title: '我的订单', route: '/my-order'),
                  IndexKingkongItem(src: 'lib/images/home/index/down-order.png', title: '下级订单', route: '/down-order'),
                  IndexKingkongItem(src: 'lib/images/home/index/my-stock.png', title: '我的库存', route: '/my-stock'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
