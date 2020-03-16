import 'package:dwbs_app_flutter/apis/app.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:dwbs_app_flutter/provider/ProviderMessage.dart';
import 'package:provider/provider.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageMessageOrder extends StatefulWidget {
  PageMessageOrder({Key key}) : super(key: key);

  @override
  _PageMessageOrderState createState() => _PageMessageOrderState();
}

class _PageMessageOrderState extends State<PageMessageOrder> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _loading = false;
  ProviderMessage __message;
  TabController _tabController;

  // 批量设置消息为已读
  void _readMessages() {
    if (this._tabController.index == 0 && this.__message.myOrderMessageNum != 0) {
      if (!this._loading) {
        setState(() => this._loading = true);
      }
      apiReadMessage({'type': 2}).then((status) {
        this.__message.clearUnreadOrderMessages(this._tabController.index);
      }).whenComplete(() {
        setState(() => this._loading = false);
      });
    }
    if (this._tabController.index == 1 && this.__message.downOrderMessageNum != 0) {
      setState(() => this._loading = true);
      apiReadMessage({'type': 3}).then((status) {
        this.__message.clearUnreadOrderMessages(this._tabController.index);
      }).whenComplete(() {
        setState(() => this._loading = false);
      });
    }
  }

  // 设置单个消息为已读
  void _readMessage(type, index, orderNum) {
    this.__message.readMessage(type, index);
    Navigator.of(context).pushNamed('/order-detail', arguments: {
      'order_num': orderNum,
      'forward': false,
    });
  }

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    // 左右拖动改变 tabIndex
    this._tabController.addListener(() {
      if (!this._tabController.indexIsChanging) {
        this._readMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderMessage message, Widget child) {
      if (this.__message == null) {
        this.__message = message;
        if (this.__message.myOrderMessageNum > 0) {
          this._loading = true;
          this._readMessages();
        }
      }
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '订单通知'),
          body: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: Ycn.px(70),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    indicatorWeight: Ycn.px(2),
                    controller: this._tabController,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: Ycn.px(-34)),
                    tabs: [
                      Tab(text: this.__message.myOrderMessageNum > 0 ? '我的订单(${this.__message.myOrderMessageNum})' : '我的订单'),
                      Tab(text: this.__message.downOrderMessageNum > 0 ? '下级订单(${this.__message.downOrderMessageNum})' : '下级订单')
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: this._tabController,
                  children: <Widget>[
                    this.__message.myOrderMessageByDate.keys.toList().length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: Ycn.px(10)),
                            itemCount: this.__message.myOrderMessageByDate.keys.toList().length,
                            itemBuilder: (BuildContext context, int index) {
                              final key = this.__message.myOrderMessageByDate.keys.toList()[index];
                              final value = this.__message.myOrderMessageByDate.values.toList()[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: Ycn.px(58),
                                    alignment: Alignment(0, 0),
                                    child: Text(key, style: TextStyle(fontSize: Ycn.px(24))),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Ycn.px(10)),
                                    child: Container(
                                      width: Ycn.px(690),
                                      child: Column(
                                        children: <Widget>[
                                          ...value
                                              .map(
                                                (orderItem) => Stack(
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Container(
                                                          height: Ycn.px(57),
                                                          color: Colors.white,
                                                          margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Text('订单编号：${orderItem['order_num']}', style: TextStyle(fontSize: Ycn.px(26))),
                                                              Row(
                                                                children: <Widget>[
                                                                  Text(
                                                                    '${Ycn.formatTime(orderItem['time'], array: true)[4]}:${Ycn.formatTime(orderItem['time'], array: true)[5]}',
                                                                    style: TextStyle(fontSize: Ycn.px(24)),
                                                                  ),
                                                                  orderItem['readed'] == true
                                                                      ? Container(width: 0, height: 0)
                                                                      : Container(
                                                                          width: Ycn.px(10),
                                                                          height: Ycn.px(10),
                                                                          margin: EdgeInsets.only(left: Ycn.px(10)),
                                                                          decoration: BoxDecoration(
                                                                            color: Theme.of(context).accentColor,
                                                                            borderRadius: BorderRadius.circular(Ycn.px(10)),
                                                                          ),
                                                                        ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          children: <Widget>[
                                                            ...orderItem['goodList']
                                                                .map(
                                                                  (good) => Container(
                                                                    height: Ycn.px(190),
                                                                    color: Colors.white,
                                                                    padding: EdgeInsets.all(Ycn.px(30)),
                                                                    margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: <Widget>[
                                                                        Image.network(good['img'],
                                                                            width: Ycn.px(120), height: Ycn.px(120), fit: BoxFit.fill),
                                                                        SizedBox(width: Ycn.px(30)),
                                                                        Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Text(good['name'], style: TextStyle(fontSize: Ycn.px(26))),
                                                                              Text(
                                                                                '数量：${good['num']}件',
                                                                                style: TextStyle(
                                                                                  fontSize: Ycn.px(26),
                                                                                  color: Theme.of(context).textTheme.display1.color,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '金额：￥${good['num'] * good['price']}',
                                                                                style: TextStyle(
                                                                                  fontSize: Ycn.px(26),
                                                                                  color: Theme.of(context).accentColor,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList()
                                                          ],
                                                        ),
                                                        Container(
                                                          height: Ycn.px(71),
                                                          color: Colors.white,
                                                          padding: EdgeInsets.only(left: Ycn.px(30)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Text(
                                                                '${Ycn.formatOrderStatus(orderItem['status'])}',
                                                                style: TextStyle(
                                                                  fontSize: Ycn.px(24),
                                                                  color: Theme.of(context).textTheme.display1.color,
                                                                ),
                                                              ),
                                                              Container(
                                                                height: double.infinity,
                                                                child: Material(
                                                                  color: Colors.transparent,
                                                                  child: InkWell(
                                                                    onTap: () =>
                                                                        this._readMessage(0, orderItem['index'], orderItem['order_num']),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        SizedBox(width: Ycn.px(30)),
                                                                        Text(
                                                                          '查看详情',
                                                                          style: TextStyle(
                                                                            height: 1.25,
                                                                            fontSize: Ycn.px(26),
                                                                            color: Theme.of(context).accentColor,
                                                                          ),
                                                                        ),
                                                                        Icon(
                                                                          Icons.arrow_forward_ios,
                                                                          size: Ycn.px(30),
                                                                          color: Theme.of(context).accentColor,
                                                                        ),
                                                                        SizedBox(width: Ycn.px(30))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: Ycn.px(10)),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      top: Ycn.px(66),
                                                      right: Ycn.px(34),
                                                      child: Image.asset('lib/images/public/pass.png', width: Ycn.px(70), height: Ycn.px(70)),
                                                    )
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            })
                        : Center(child: Text('空空如也...')),
                    this.__message.downOrderMessageByDate.keys.toList().length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: Ycn.px(10)),
                            itemCount: this.__message.downOrderMessageByDate.keys.toList().length,
                            itemBuilder: (BuildContext context, int index) {
                              final key = this.__message.downOrderMessageByDate.keys.toList()[index];
                              final value = this.__message.downOrderMessageByDate.values.toList()[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: Ycn.px(58),
                                    alignment: Alignment(0, 0),
                                    child: Text(key, style: TextStyle(fontSize: Ycn.px(24))),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Ycn.px(10)),
                                    child: Container(
                                      width: Ycn.px(690),
                                      child: Column(
                                        children: <Widget>[
                                          ...value
                                              .map(
                                                (orderItem) => Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: Ycn.px(57),
                                                      color: Colors.white,
                                                      margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text('订单编号：${orderItem['order_num']}', style: TextStyle(fontSize: Ycn.px(26))),
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                '${Ycn.formatTime(orderItem['time'], array: true)[4]}:${Ycn.formatTime(orderItem['time'], array: true)[5]}',
                                                                style: TextStyle(fontSize: Ycn.px(24)),
                                                              ),
                                                              orderItem['readed'] == true
                                                                  ? Container(width: 0, height: 0)
                                                                  : Container(
                                                                      width: Ycn.px(10),
                                                                      height: Ycn.px(10),
                                                                      margin: EdgeInsets.only(left: Ycn.px(10)),
                                                                      decoration: BoxDecoration(
                                                                        color: Theme.of(context).accentColor,
                                                                        borderRadius: BorderRadius.circular(Ycn.px(10)),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: Ycn.px(160),
                                                      color: Colors.white,
                                                      width: double.infinity,
                                                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text('订单金额：￥${orderItem['price']}', style: TextStyle(fontSize: Ycn.px(26))),
                                                          Text(
                                                            '下单用户：${orderItem['nickname']}（${orderItem['phone']}）',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: Ycn.px(26)),
                                                          ),
                                                          Text('下单时间：${Ycn.formatTime(orderItem['time'])}',
                                                              style: TextStyle(fontSize: Ycn.px(26))),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: Ycn.px(77),
                                                      color: Colors.white,
                                                      padding: EdgeInsets.only(left: Ycn.px(30)),
                                                      margin: EdgeInsets.only(top: Ycn.px(1)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: <Widget>[
                                                          Container(
                                                            height: double.infinity,
                                                            child: Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () => this._readMessage(1, orderItem['index'], orderItem['order_num']),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    SizedBox(width: Ycn.px(30)),
                                                                    Text(
                                                                      '查看详情',
                                                                      style: TextStyle(
                                                                        height: 1.25,
                                                                        fontSize: Ycn.px(26),
                                                                        color: Theme.of(context).accentColor,
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      Icons.arrow_forward_ios,
                                                                      size: Ycn.px(30),
                                                                      color: Theme.of(context).accentColor,
                                                                    ),
                                                                    SizedBox(width: Ycn.px(30))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: Ycn.px(10)),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            })
                        : Center(child: Text('空空如也...')),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
