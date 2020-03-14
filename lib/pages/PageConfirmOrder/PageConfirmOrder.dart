import '../../common/Ycn.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dwbs_app_flutter/apis/order.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:dwbs_app_flutter/provider/ProviderShopCar.dart';
import 'package:dwbs_app_flutter/provider/ProviderChoosedSize.dart';

class PageConfirmOrder extends StatefulWidget {
  PageConfirmOrder({Key key}) : super(key: key);

  @override
  _PageConfirmOrderState createState() => _PageConfirmOrderState();
}

class _PageConfirmOrderState extends State<PageConfirmOrder> {
  String _from; // 上一个页面 shopCar 购物车 detail 商品详情
  Map _address; // 提交订单时选中的地址
  List _goodList; // 提交订单的商品列表
  String _orderNum; // 提交订单后返回的订单号
  int _totalNum = 0; // 提交订单的商品列表商品总数
  int _totalPrice = 0; // 提交订单的商品列表商品总价值
  bool _loading = false; // loading
  bool _submitSucc = false; // 是否下单成功
  bool _requesting = false; // 是否正在请求（防连点）
  ProviderShopCar __shopCar; // 购物车
  ProviderChoosedSize __choosed; // 商品详情页已选中
  FocusNode _focusNode = FocusNode(); // 备注 input 焦点
  TextEditingController _textEditingController = TextEditingController(); // 备注 input 控制器

  // 计算单件商品总价值
  int _getGoodPrice(goodItem) {
    return goodItem['typeList'].fold(0, (t, e) {
      return t +
          e['num'].fold(t, (tt, ee) {
            return tt + ee * goodItem['price'];
          });
    });
  }

  // 点击选择地址
  void _chooseAddress() {
    Navigator.of(context).pushNamed('/address-manage', arguments: {'choose': true}).then((res) {
      setState(() {
        this._address = res;
      });
    });
  }

  // 点击结算
  void _confirmOrder() {
    if (this._address != null) {
      this._focusNode.unfocus();
      final sendList = List();
      this._goodList.forEach((goodItem) {
        goodItem['typeList'].forEach((typeItem) {
          typeItem['size_id'].forEach((sizedId) {
            sendList.add({
              'size_id': sizedId,
              'goods_id': goodItem['id'],
              'type_id': typeItem['type_id'],
              'num': typeItem['num'][typeItem['size_id'].indexOf(sizedId)],
            });
          });
        });
      });
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiSubmitOrder({
          'remark': this._textEditingController.text,
          'address_id': this._address['id'],
          'total': this._totalPrice,
          'list': sendList,
        }).then((status) {
          if (status.data['code'].toString() == '200') {
            setState(() {
              this._submitSucc = true;
              this._orderNum = status.data['data']['order_num'];
              if (this._from == 'shopCar') {
                this.__shopCar.delChoosed(); // 删除购物车中已选中的商品
              } else if (this._from == 'detail') {
                this.__choosed.clear(); // 清除商品详情页已选中尺寸
              }
            });
          } else if (status.data['code'].toString() == '300') {
            Ycn.toast(status.data['message']);
          } else {
            Ycn.toast('下单失败，请联系客服');
          }
        }).whenComplete(() {
          setState(() {
            this._loading = false;
            this._requesting = false;
          });
        });
      }
    } else {
      Ycn.toast('还没有选择地址呢');
    }
  }

  @override
  Widget build(BuildContext context) {
    this._from = (ModalRoute.of(context).settings.arguments as Map)['from'];
    this._goodList = (ModalRoute.of(context).settings.arguments as Map)['goodLsit'];
    this._totalNum = this._goodList.fold(0, (t, goodItem) {
      return t +
          goodItem['typeList'].fold(t, (tt, typeItem) {
            return tt +
                typeItem['num'].fold(tt, (ttt, numItem) {
                  return ttt + numItem;
                });
          });
    });
    this._totalPrice = this._goodList.fold(0, (t, e) {
      return t + this._getGoodPrice(e);
    });
    return Consumer2(builder: (BuildContext context, ProviderShopCar shopCar, ProviderChoosedSize choosed, Widget child) {
      this.__choosed = choosed;
      this.__shopCar = shopCar;
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '确定订单'),
          body: this._submitSucc
              ? Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: Ycn.px(95)),
                      Icon(Icons.check_circle, color: Theme.of(context).accentColor, size: Ycn.px(228)),
                      SizedBox(height: Ycn.px(100)),
                      Text('下单成功，请等待上级审核发货...', style: TextStyle(fontSize: Ycn.px(36))),
                      SizedBox(height: Ycn.px(121)),
                      Container(
                        width: Ycn.px(480),
                        height: Ycn.px(88),
                        child: FlatButton(
                          onPressed: () => Navigator.of(context).pushNamed('/order-detail', arguments: {'order_num': this._orderNum}),
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                          child: Text('查看订单', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
                        ),
                      ),
                      SizedBox(height: Ycn.px(30)),
                      Container(
                        width: Ycn.px(480),
                        height: Ycn.px(88),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Ycn.px(88)),
                          border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                        ),
                        child: FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                          child: Text('我知道了', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(34))),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(minHeight: Ycn.px(160)),
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: this._chooseAddress,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('收货人：${this._address == null ? '未选择' : this._address['con_name']}',
                                                style: TextStyle(fontSize: Ycn.px(32))),
                                            Text('${this._address == null ? '' : this._address['con_mobile']}',
                                                style: TextStyle(fontSize: Ycn.px(26))),
                                          ],
                                        ),
                                        Text(
                                          '${this._address == null ? '' : Ycn.formatAddress(this._address)}',
                                          style: TextStyle(fontSize: Ycn.px(26), height: 1.423),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Ycn.px(10)),
                            ...this._goodList.map((goodItem) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    height: Ycn.px(180),
                                    color: Colors.white,
                                    margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.network(goodItem['img'], width: Ycn.px(140), height: Ycn.px(140), fit: BoxFit.cover),
                                        SizedBox(width: Ycn.px(40)),
                                        Text(goodItem['name'],
                                            maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32)))
                                      ],
                                    ),
                                  ),
                                  ...goodItem['typeList']
                                      .map((typeItem) => Column(
                                            children: <Widget>[
                                              ...typeItem['size']
                                                  .map((sizeItem) => Container(
                                                        height: Ycn.px(103),
                                                        color: Colors.white,
                                                        margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                        padding: EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Row(
                                                                  children: <Widget>[
                                                                    Text('款式：${typeItem['name']}', style: TextStyle(fontSize: Ycn.px(26))),
                                                                    SizedBox(width: Ycn.px(54)),
                                                                    Text('尺码：${sizeItem}', style: TextStyle(fontSize: Ycn.px(26))),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '￥${goodItem['price'] * typeItem['num'][typeItem['size'].indexOf(sizeItem)] + 0.0}',
                                                                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(26)),
                                                                )
                                                              ],
                                                            ),
                                                            Text(
                                                              '×${typeItem['num'][typeItem['size'].indexOf(sizeItem)]}',
                                                              style: TextStyle(fontSize: Ycn.px(32)),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ],
                                          ))
                                      .toList(),
                                  Container(
                                    height: Ycn.px(90),
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('总计金额'),
                                        Text('￥${this._getGoodPrice(goodItem)}.00',
                                            style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor))
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            SizedBox(height: Ycn.px(10)),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('备注：', style: TextStyle(fontSize: Ycn.px(26))),
                                  Expanded(
                                    child: TextField(
                                      maxLines: 1,
                                      cursorWidth: Ycn.px(6),
                                      focusNode: this._focusNode,
                                      textInputAction: TextInputAction.done,
                                      controller: this._textEditingController,
                                      cursorRadius: Radius.circular(Ycn.px(2)),
                                      cursorColor: Theme.of(context).accentColor,
                                      style: TextStyle(fontSize: Ycn.px(26), height: 1.25),
                                      decoration: InputDecoration(
                                        hintText: '(选填)',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
                                      ),
                                      inputFormatters: [LengthLimitingTextInputFormatter(120)],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: Ycn.px(98),
                      color: Colors.white,
                      padding: EdgeInsets.only(left: Ycn.px(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('共${this._totalNum}件商品', style: TextStyle(fontSize: Ycn.px(32))),
                          Row(
                            children: <Widget>[
                              Text('总计:', style: TextStyle(fontSize: Ycn.px(32))),
                              Text('￥${this._totalPrice + 0.0}', style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                            ],
                          ),
                          Container(
                            width: Ycn.px(220),
                            color: Theme.of(context).accentColor,
                            child: MaterialInkWell(
                              onTap: this._confirmOrder,
                              child: Center(
                                child: Text('结算(${this._totalNum})', style: TextStyle(color: Colors.white, fontSize: Ycn.px(32))),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      );
    });
  }
}
