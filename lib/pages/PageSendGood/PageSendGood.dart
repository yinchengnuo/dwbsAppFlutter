import '../../common/Ycn.dart';
import '../../common/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/apis/order.dart';
import 'package:dwbs_app_flutter/common/components.dart';

class PageSendGood extends StatefulWidget {
  PageSendGood({Key key}) : super(key: key);

  @override
  _PageSendGoodState createState() => _PageSendGoodState();
}

class _PageSendGoodState extends State<PageSendGood> with SingleTickerProviderStateMixin {
  Map _data;
  int _index = 0;
  bool _loading = false;
  String order_num = '';
  List _actionData = List();
  TabController _tabController;

  // 请求订单数据
  void _request(arguments) {
    this._index = arguments['index'];
    this.order_num = arguments['order_num'].toString();
    apiOrderDetail({'order_num': arguments['order_num'], 'type': 'normal'}).then((status) {
      setState(() {
        this._data = status.data['data'];
        List sendList = Ycn.clone(this._data['goodList']);
        sendList.forEach((goodItem) {
          goodItem['typeList'].forEach((typeItem) {
            typeItem['num'] = List.filled(typeItem['size'].length, 0);
          });
        });
        this._actionData.add(sendList);
        this._actionData.add(Ycn.clone(this._data['goodList']));
      });
    });
  }

  // 发货数量发生变化
  void _numChange(actionIndex, goodIndex, typeIndex, sizeIndex, value) {
    setState(() {
      if (actionIndex == 0) {
        this._actionData[1][goodIndex]['typeList'][typeIndex]['num'][sizeIndex] -=
            (value - this._actionData[0][goodIndex]['typeList'][typeIndex]['num'][sizeIndex]);
        this._actionData[0][goodIndex]['typeList'][typeIndex]['num'][sizeIndex] = value;
      } else if (actionIndex == 1) {
        this._actionData[0][goodIndex]['typeList'][typeIndex]['num'][sizeIndex] -=
            (value - this._actionData[1][goodIndex]['typeList'][typeIndex]['num'][sizeIndex]);
        this._actionData[1][goodIndex]['typeList'][typeIndex]['num'][sizeIndex] = value;
      }
    });
  }

  // 确认转单/发货
  void _confirm(context, forward) async {
    final int sendNum = this._getOrderNum(this._actionData[0]);
    final int forwardNum = this._getOrderNum(this._actionData[1]);
    if (forward) {
      if (forwardNum == 0) {
        Ycn.toast('发货单暂无商品');
      } else if (sendNum == 0) {
        if ((await Ycn.modal(context, content: ['您选择了全部转单', '转单数量：$forwardNum套'])) != null) {
          this._send(1, 1);
        }
      } else {
        if ((await Ycn.modal(context, content: ['您选择了部分转单，其余部分将自动发货', '转单数量：$forwardNum套', '发货数量：$sendNum套'])) != null) {
          this._send(2, 1);
        }
      }
    } else {
      if (sendNum == 0) {
        Ycn.toast('发货单暂无商品');
      } else if (forwardNum == 0) {
        if ((await Ycn.modal(context, content: ['您选择了全部发货', '发货数量：$sendNum套'])) != null) {
          this._send(0, 0);
        }
      } else {
        if ((await Ycn.modal(context, content: ['您选择了部分发货，其余部分将自动转单', '发货数量：$sendNum套', '转单数量：$forwardNum套'])) != null) {
          this._send(2, 0);
        }
      }
    }
  }

  // 获取货单数量
  int _getOrderNum(goodList) {
    return goodList.fold(0, (t, goodItem) {
      return goodItem['typeList'].fold(t, (tt, typeItem) {
        return typeItem['num'].fold(tt, (ttt, eee) {
          return ttt + eee;
        });
      });
    });
  }

  // 发货/转单
  void _send(status, action) {
    setState(() {
      this._loading = true;
    });
    List list = List();
    if (status != 0) {
      this._actionData[1].forEach((goodItem) {
        goodItem['typeList'].forEach((typeItem) {
          typeItem['size_id'].forEach((sizedId) {
            if (typeItem['num'][typeItem['size_id'].indexOf(sizedId)] > 0) {
              list.add({
                'size_id': sizedId,
                'goods_id': goodItem['id'],
                'type_id': typeItem['type_id'],
                'num': typeItem['num'][typeItem['size_id'].indexOf(sizedId)],
              });
            }
          });
        });
      });
    }
    apiSendGood({'order_num': this.order_num, 'status': status, 'remark': '', 'list': list}).whenComplete(() {
      setState(() {
        this._loading = false;
        EventBus().emit('SEND_ORDER', this._index);
        Navigator.of(context).pushReplacementNamed('/send-success', arguments: {'forward': action == 1});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (this._data == null) {
      this._request(ModalRoute.of(context).settings.arguments as Map);
    }
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '发货确认'),
        body: this._data == null
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: Ycn.px(84),
                          child: Material(
                            color: Colors.white,
                            child: TabBar(
                              controller: this._tabController,
                              indicatorWeight: Ycn.px(6),
                              indicatorPadding: EdgeInsets.fromLTRB(Ycn.px(14), 0, Ycn.px(14), 0),
                              tabs: [
                                Tab(text: '发货单(${this._getOrderNum(this._actionData[0])})'),
                                Tab(text: '转货单(${this._getOrderNum(this._actionData[1])})')
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: this._tabController,
                            physics: ClampingScrollPhysics(),
                            children: [
                              ...this
                                  ._actionData
                                  .map(
                                    (actionItem) => Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: this._getOrderNum(actionItem) == 0
                                              ? Center(
                                                  child: Text('空空如也...'),
                                                )
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      ...actionItem
                                                          .map(
                                                            (goodItem) => Column(
                                                              children: <Widget>[
                                                                goodItem['typeList'].fold(0,
                                                                            (t, typeItem) => t + typeItem['num'].fold(t, (tt, ee) => tt + ee)) ==
                                                                        0
                                                                    ? Container(width: 0, height: 0)
                                                                    : Container(
                                                                        height: Ycn.px(180),
                                                                        color: Colors.white,
                                                                        margin: EdgeInsets.only(top: Ycn.px(10)),
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Image.network(goodItem['img'],
                                                                                width: Ycn.px(140), height: Ycn.px(140), fit: BoxFit.cover),
                                                                            SizedBox(width: Ycn.px(40)),
                                                                            Text(
                                                                              goodItem['name'],
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: Ycn.px(32)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                ...goodItem['typeList']
                                                                    .map(
                                                                      (typeItem) => Column(
                                                                        children: <Widget>[
                                                                          ...typeItem['size'].map(
                                                                            (sizeItem) {
                                                                              final int actionIndex = this._actionData.indexOf(actionItem);
                                                                              final int goodIndex = actionItem.indexOf(goodItem);
                                                                              final int typeIndex = goodItem['typeList'].indexOf(typeItem);
                                                                              final int sizeIndex = typeItem['size'].indexOf(sizeItem);
                                                                              return typeItem['num'][typeItem['size'].indexOf(sizeItem)] == 0
                                                                                  ? Container(width: 0, height: 0)
                                                                                  : Container(
                                                                                      height: Ycn.px(90),
                                                                                      color: Colors.white,
                                                                                      margin: EdgeInsets.only(top: Ycn.px(1)),
                                                                                      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: <Widget>[
                                                                                          Row(
                                                                                            children: <Widget>[
                                                                                              Text(
                                                                                                '款式：${typeItem['name']}',
                                                                                                style: TextStyle(fontSize: Ycn.px(26)),
                                                                                              ),
                                                                                              SizedBox(width: Ycn.px(54)),
                                                                                              Text(
                                                                                                '尺码：${sizeItem}',
                                                                                                style: TextStyle(fontSize: Ycn.px(26)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          CustomCounter(
                                                                                            onChange: (value) => this._numChange(actionIndex,
                                                                                                goodIndex, typeIndex, sizeIndex, value),
                                                                                            value: typeItem['num']
                                                                                                [typeItem['size'].indexOf(sizeItem)],
                                                                                            max: this._data['goodList'][goodIndex]['typeList']
                                                                                                [typeIndex]['num'][sizeIndex],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                            },
                                                                          ).toList(),
                                                                        ],
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                              ],
                                                            ),
                                                          )
                                                          .toList(),
                                                      SizedBox(height: Ycn.px(10)),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        Container(
                                          height: Ycn.px(98),
                                          width: double.infinity,
                                          child: FlatButton(
                                            onPressed: () => this._confirm(context, !(this._actionData.indexOf(actionItem) == 0)),
                                            color: Theme.of(context).accentColor,
                                            child: Text(
                                              this._actionData.indexOf(actionItem) == 0
                                                  ? '确认发货(${this._getOrderNum(actionItem)})'
                                                  : '确认转单(${this._getOrderNum(actionItem)})',
                                              style: TextStyle(fontSize: Ycn.px(32), color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
