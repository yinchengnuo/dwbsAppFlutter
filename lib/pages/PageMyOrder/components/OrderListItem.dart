import '../../../common/Ycn.dart';
import '../../../apis/order.dart';
import 'package:flutter/material.dart';
import '../../../common/EventBus.dart';

class OrderListItemWrapper extends StatelessWidget {
  final index, data, name, page, last;
  const OrderListItemWrapper({Key key, this.data, this.name, this.page, this.last, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              OrderListItem(index: this.index, data: this.data, name: this.name),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(
                  child: Text(
                    page == 0 ? '没有更多了' : '加载中...',
                    style: TextStyle(
                      fontSize: Ycn.px(28),
                    ),
                  ),
                ),
              ),
            ],
          )
        : OrderListItem(index: this.index, data: this.data, name: this.name);
  }
}

class OrderListItem extends StatelessWidget {
  final index, data, name;
  const OrderListItem({Key key, this.data, this.name, this.index}) : super(key: key);

  // 删除订单
  void _delOrder(context) {
    Ycn.modal(context, content: ['确定删除此订单？']).then((res) {
      if (res != null) {
        EventBus().emit('DOWN_ORDER_LOADING');
        apiDelOrder({'order_num': this.data['order_num']}).then((status) {
          EventBus().emit('DELETE_ORDER', this.index);
        }).whenComplete(() {
          EventBus().emit('DOWN_ORDER_HIDELOADING');
        });
      }
    });
  }

  // 确认收款
  void _receiveMoney(context) {
    Ycn.modal(context, content: ['确定收到货款？']).then((res) {
      if (res != null) {
        EventBus().emit('DOWN_ORDER_LOADING');
        apiReveiveMonkey({'order_num': this.data['order_num']}).then((status) {
          EventBus().emit('RECEIVE_MONEY', this.index);
        }).whenComplete(() {
          EventBus().emit('DOWN_ORDER_HIDELOADING');
        });
      }
    });
  }

  // 确认收货
  void _receiveGoods(context) {
    Ycn.modal(context, content: ['确定收到货物？']).then((res) {
      if (res != null) {
        EventBus().emit('MY_ORDER_LOADING');
        apiReveiveGoods({'order_num': this.data['order_num']}).then((status) {
          EventBus().emit('RECEIVE_GOODS', this.index);
        }).whenComplete(() {
          EventBus().emit('MY_ORDER_HIDELOADING');
        });
      }
    });
  }

  // 去发货
  void _sendGoods(context) {
    Navigator.of(context).pushNamed('/send-good', arguments: {'order_num': this.data['order_num'], 'index': this.index});
  }

  // 查看订单/转单
  void _orderDetail(context, forward) {
    Navigator.of(context).pushNamed('/order-detail', arguments: {'order_num': this.data['order_num'], 'forward': forward});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: Ycn.px(10)),
        Container(
          height: Ycn.px(90),
          color: Colors.white,
          margin: EdgeInsets.only(bottom: Ycn.px(1)),
          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('订单编号：${data['order_num']}', style: TextStyle(fontSize: Ycn.px(26))),
              Text(
                this.name == '我的订单待审核' || this.name == '下级订单待审核' ? '未付款' : '',
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(26)),
              )
            ],
          ),
        ),
        ...this
            .data['goodList']
            .map((goodItem) => Container(
                  height: Ycn.px(180),
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: Ycn.px(1)),
                  padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(20)),
                  child: Row(
                    children: <Widget>[
                      Image.network(goodItem['img'], width: Ycn.px(140), height: Ycn.px(140)),
                      SizedBox(width: Ycn.px(40)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(goodItem['name'], style: TextStyle(fontSize: Ycn.px(32), height: 1.25)),
                            SizedBox(height: Ycn.px(8)),
                            Text('数量：${goodItem['num']}件',
                                style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color)),
                            Text('金额：￥${goodItem['num'] * goodItem['price']}',
                                style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            .toList(),
        Container(
          height: Ycn.px(103),
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('订单合计：', style: TextStyle(fontSize: Ycn.px(26))),
                  Text(
                    '￥${this.data['goodList'].fold(0, (t, e) => t + e['num'] * e['price'])}',
                    style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      this.name == '下级订单待审核'
                          ? OrderListItemButton(title: '删除订单', grey: true, onTap: () => this._delOrder(context))
                          : Container(width: 0, height: 0),
                      this.name == '下级订单待审核'
                          ? OrderListItemButton(title: '确认收款', onTap: () => this._receiveMoney(context))
                          : Container(width: 0, height: 0),
                      this.name == '我的订单待收货'
                          ? OrderListItemButton(title: '确认收货', onTap: () => this._receiveGoods(context))
                          : Container(width: 0, height: 0),
                      (this.name == '我的订单待收货' || this.name == '我的订单已完成') && this.data['forward']
                          ? OrderListItemButton(title: '查看转单', onTap: () => this._orderDetail(context, true))
                          : Container(width: 0, height: 0),
                      this.name == '下级订单待发货'
                          ? OrderListItemButton(title: '去发货', onTap: () => this._sendGoods(context))
                          : Container(width: 0, height: 0),
                      this.name == '下级订单已转单'
                          ? OrderListItemButton(title: '查看转单', onTap: () => this._orderDetail(context, true))
                          : OrderListItemButton(title: '查看订单', onTap: () => this._orderDetail(context, false)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderListItemButton extends StatelessWidget {
  final title, grey, onTap;
  const OrderListItemButton({Key key, this.title, this.grey = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ycn.px(132),
      height: Ycn.px(48),
      margin: EdgeInsets.only(left: Ycn.px(30)),
      decoration: BoxDecoration(
        border: Border.all(width: Ycn.px(3), color: this.grey ? Theme.of(context).textTheme.display1.color : Theme.of(context).accentColor),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: this.onTap,
        child: Text(
          this.title,
          style: TextStyle(color: this.grey ? Theme.of(context).textTheme.display1.color : Theme.of(context).accentColor, fontSize: Ycn.px(26)),
        ),
      ),
    );
  }
}
