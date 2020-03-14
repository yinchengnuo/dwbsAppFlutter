import 'package:dwbs_app_flutter/apis/order.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageOrderDetail extends StatefulWidget {
  PageOrderDetail({Key key}) : super(key: key);

  @override
  _PageOrderDetailState createState() => _PageOrderDetailState();
}

class _PageOrderDetailState extends State<PageOrderDetail> {
  Map _data;
  bool _forward;
  int _totalPrice = 0;

  void _request(arguments) {
    apiOrderDetail({'order_num': arguments['order_num'], 'type': arguments['forward'] ? 'turn' : 'normal '}).then((status) {
      setState(() {
        this._data = status.data['data'];
        // 计算订单商品总价值
        setState(() {
          this._data['goodList'].forEach((goodItem) {
            goodItem['typeList'].forEach((typeItem) {
              typeItem['num'].forEach((numItem) {
                this._totalPrice += numItem * goodItem['price'];
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this._data == null) {
      setState(() {
        this._request(ModalRoute.of(context).settings.arguments as Map);
        this._forward = (ModalRoute.of(context).settings.arguments as Map)['forward'];
      });
    }
    return Scaffold(
      appBar: Ycn.appBar(context, title: this._forward ? '转单详情' : '订单详情'),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: Ycn.px(160)),
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: Ycn.px(10)),
                      padding: EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: Ycn.px(456)),
                                child: Text('收货人：${this._data['address']['con_name']}',
                                    maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                              ),
                              Text(this._data['address']['con_mobile'], style: TextStyle(fontSize: Ycn.px(26)))
                            ],
                          ),
                          SizedBox(height: Ycn.px(8)),
                          Text(this._data['address']['address'], textAlign: TextAlign.left, style: TextStyle(fontSize: Ycn.px(26), height: 1.25))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: Ycn.px(60),
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: Ycn.px(1)),
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('订单编号：${this._data['order_num']}', style: TextStyle(fontSize: Ycn.px(26)))],
                    ),
                  ),
                  Container(
                    height: Ycn.px(60),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('下单时间：${Ycn.formatTime(this._data['time'])}', style: TextStyle(fontSize: Ycn.px(26))),
                      ],
                    ),
                  ),
                  ...this
                      ._data['goodList']
                      .map(
                        (goodItem) => Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: Ycn.px(180),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(20)),
                                margin: EdgeInsets.only(top: Ycn.px(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(goodItem['img'], width: Ycn.px(140), fit: BoxFit.cover),
                                    SizedBox(width: Ycn.px(40)),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${goodItem['name']}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: Ycn.px(32), height: 1.25),
                                          ),
                                          Text('进货价：￥${goodItem['price']}',
                                              style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                                          Text('我的库存：${goodItem['storage']}',
                                              style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ...goodItem['typeList']
                                  .map(
                                    (typeItem) => Column(
                                      children: <Widget>[
                                        ...typeItem['size']
                                            .map(
                                              (sizeItem) => Container(
                                                height: Ycn.px(103),
                                                color: Colors.white,
                                                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(20)),
                                                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text('款式：男款', style: TextStyle(fontSize: Ycn.px(26))),
                                                            SizedBox(width: Ycn.px(54)),
                                                            Text('尺码：${sizeItem}', style: TextStyle(fontSize: Ycn.px(26))),
                                                          ],
                                                        ),
                                                        Text('¥${typeItem['num'][typeItem['size'].indexOf(sizeItem)] * goodItem['price']}',
                                                            style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(26)))
                                                      ],
                                                    ),
                                                    Text('×${typeItem['num'][typeItem['size'].indexOf(sizeItem)]}'),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    margin: EdgeInsets.only(top: Ycn.px(10)),
                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30), vertical: Ycn.px(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('总计金额', style: TextStyle(fontSize: Ycn.px(26))),
                        Text('￥${this._totalPrice}', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: Ycn.px(90)),
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: Ycn.px(10)),
                      padding: EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('备注：', style: TextStyle(fontSize: Ycn.px(26))),
                          Expanded(
                            child: Text(this._data['remark'], style: TextStyle(fontSize: Ycn.px(26), height: 1.25)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
