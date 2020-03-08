import '../../common/Ycn.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../provider/ProviderShopCar.dart';

class PageShopCar extends StatefulWidget {
  PageShopCar({Key key}) : super(key: key);

  @override
  _PageShopCarState createState() => _PageShopCarState();
}

class _PageShopCarState extends State<PageShopCar> {
  bool _isDelMode = false;
  ProviderShopCar __shopCar;

  // 切换模式 删除
  void _switchMode() {
    setState(() {
      this._isDelMode = !this._isDelMode;
    });
  }

  // 从购物车删除商品
  Future _delGood(goodIndex) async {
    if (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CustomModal(
            content: ['确定将', this.__shopCar.shopCar[goodIndex]['name'], '从购物车删除?'],
          ),
        ) !=
        null) {
      this.__shopCar.delGood(goodIndex);
      setState(() {
        this.__shopCar.totalNum == 0 ? this._isDelMode = false : '';
      });
    }
  }

  // 点击 删除 / 结算
  void _comfirm() async {
    if (this._isDelMode) {
      if (this.__shopCar.totalChoosedNum > 0) {
        if (await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => CustomModal(
                content: ['确定将这${this.__shopCar.totalChoosedNum}件商品从购物车删除?'],
              ),
            ) !=
            null) {
          this.__shopCar.delChoosed();
          setState(() {
            this.__shopCar.totalNum == 0 ? this._isDelMode = false : '';
          });
        }
      } else {
        Ycn.toast('请选择需要删除的商品');
      }
    } else {
      if (this.__shopCar.totalNum > 0) {

      } else {
        Ycn.toast('购物车中还没有商品呢');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ProviderShopCar shopCar, Widget child) {
        this.__shopCar = shopCar;
        return Scaffold(
          appBar: Ycn.appBar(context,
              title: '购物车',
              action: this.__shopCar.totalNum > 0
                  ? AppBarTextAction(text: this._isDelMode ? '完成' : '管理', onTap: this._switchMode)
                  : Container(width: 0, height: 0)),
          body: Column(
            children: <Widget>[
              Expanded(
                child: this.__shopCar.totalNum > 0
                    ? ListView.builder(
                        itemCount: this.__shopCar.shopCar.length,
                        itemBuilder: (BuildContext context, int index) => Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: Ycn.px(180),
                                color: Colors.white,
                                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: Ycn.px(90),
                                      child: MaterialInkWell(
                                        onTap: () => this.__shopCar.chooseChange([index, this.__shopCar.shopCar[index]['choosed']]),
                                        child: Center(
                                          child: Icon(
                                            this.__shopCar.shopCar[index]['choosed'] ? Icons.check_circle : Icons.radio_button_unchecked,
                                            size: Ycn.px(34),
                                            color: this.__shopCar.shopCar[index]['choosed']
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context).textTheme.display1.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Image.network(this.__shopCar.shopCar[index]['img'], width: Ycn.px(140), height: Ycn.px(140)),
                                    SizedBox(width: Ycn.px(40)),
                                    Expanded(
                                      child: Text(
                                        '${this.__shopCar.shopCar[index]['name']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: Ycn.px(32)),
                                      ),
                                    ),
                                    Container(
                                      width: Ycn.px(190),
                                      child: MaterialInkWell(
                                        onTap: () => this._delGood(index),
                                        child: Center(
                                          child: Icon(Icons.delete_outline, color: Theme.of(context).textTheme.display1.color, size: Ycn.px(54)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...this
                                  .__shopCar
                                  .shopCar[index]['typeList']
                                  .map((typeItem) => Container(
                                        child: Column(
                                          children: <Widget>[
                                            ...typeItem['size']
                                                .map(
                                                  (sizeItem) => Container(
                                                    height: Ycn.px(103),
                                                    color: Colors.white,
                                                    margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: Ycn.px(90),
                                                          child: MaterialInkWell(
                                                            onTap: () => this.__shopCar.chooseChange([
                                                              index,
                                                              this.__shopCar.shopCar[index]['typeList'].indexOf(typeItem),
                                                              typeItem['size'].indexOf(sizeItem),
                                                              typeItem['choosed'][typeItem['size'].indexOf(sizeItem)]
                                                            ]),
                                                            child: Center(
                                                              child: Icon(
                                                                typeItem['choosed'][typeItem['size'].indexOf(sizeItem)]
                                                                    ? Icons.check_circle
                                                                    : Icons.radio_button_unchecked,
                                                                size: Ycn.px(34),
                                                                color: typeItem['choosed'][typeItem['size'].indexOf(sizeItem)]
                                                                    ? Theme.of(context).accentColor
                                                                    : Theme.of(context).textTheme.display1.color,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Text('款式：${typeItem['name']}', style: TextStyle(fontSize: Ycn.px(26))),
                                                                  SizedBox(width: Ycn.px(54)),
                                                                  Text('尺码：${sizeItem}', style: TextStyle(fontSize: Ycn.px(26))),
                                                                ],
                                                              ),
                                                              SizedBox(height: Ycn.px(18.29)),
                                                              Text(
                                                                '￥${this.__shopCar.shopCar[index]['price'] * typeItem['num'][typeItem['size'].indexOf(sizeItem)]}.00',
                                                                style: TextStyle(
                                                                  color: Theme.of(context).accentColor,
                                                                  fontSize: Ycn.px(26),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        CustomCounter(
                                                            min: 1,
                                                            value: typeItem['num'][typeItem['size'].indexOf(sizeItem)],
                                                            onChange: (val) {
                                                              this.__shopCar.numChange(
                                                                    index,
                                                                    this.__shopCar.shopCar[index]['typeList'].indexOf(typeItem),
                                                                    typeItem['size'].indexOf(sizeItem),
                                                                    val,
                                                                  );
                                                            }),
                                                        SizedBox(
                                                          width: Ycn.px(32),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                .toList()
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              SizedBox(height: Ycn.px(10))
                            ],
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('lib/images/public/empty-shopcar.png', width: Ycn.px(305), height: Ycn.px(417)),
                          SizedBox(height: Ycn.px(158)),
                          Container(
                              width: Ycn.px(280),
                              height: Ycn.px(80),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Ycn.px(80)),
                                border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor),
                              ),
                              child: FlatButton(
                                onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName('/good-list')),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                                child: Text('去下单', style: TextStyle(fontSize: Ycn.px(30), color: Theme.of(context).accentColor)),
                              )),
                        ],
                      ),
              ),
              Container(
                height: Ycn.px(98),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: Ycn.px(180),
                      child: MaterialInkWell(
                        onTap: () => this.__shopCar.chooseChange([this.__shopCar.isAllChoosed]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              this.__shopCar.isAllChoosed ? Icons.check_circle : Icons.radio_button_unchecked,
                              size: Ycn.px(34),
                              color: this.__shopCar.isAllChoosed ? Theme.of(context).accentColor : Theme.of(context).textTheme.display1.color,
                            ),
                            SizedBox(width: Ycn.px(30), height: double.infinity),
                            Text('全选', style: TextStyle(fontSize: Ycn.px(32)))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(this._isDelMode ? '' : '总计:', style: TextStyle(fontSize: Ycn.px(32))),
                          Text(
                            this._isDelMode ? '' : '￥${this.__shopCar.totalChoosedPrice}.00',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Ycn.px(220),
                      color: Theme.of(context).accentColor,
                      child: MaterialInkWell(
                        onTap: this._comfirm,
                        child: Center(
                          child: Text(
                            '${this._isDelMode ? '删除' : '结算'}(${this.__shopCar.totalChoosedNum})',
                            style: TextStyle(fontSize: Ycn.px(32), color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
