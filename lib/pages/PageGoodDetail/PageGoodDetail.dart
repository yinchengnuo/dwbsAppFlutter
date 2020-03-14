import '../../apis/good.dart';
import '../../common/Ycn.dart';
import '../../common/shopCar.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ProviderShopCar.dart';
import '../../provider/ProviderChoosedSize.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PageGoodDetail extends StatefulWidget {
  PageGoodDetail({Key key}) : super(key: key);

  @override
  _PageGoodDetailState createState() => _PageGoodDetailState();
}

class _PageGoodDetailState extends State<PageGoodDetail> {
  Map _data;
  bool _loading = true;
  ProviderShopCar __shopCar;
  ProviderChoosedSize __choosedSize;

  // 网络请求方法
  Future _request(data) async {
    final res = (await apiGoodDetail(data)).data;
    setState(() {
      this._data = res['data'];
      this._loading = false;
      this.__choosedSize.init(this._data['typeList']);
    });
  }

  // 点击加入购物车
  void _addShopCar() {
    if (this.__choosedSize.choosedTotal > 0) {
      this.__shopCar.add(beforeAddToShopCar(Ycn.clone(this._data), Ycn.clone(this.__choosedSize.choosedList))); // 加入购物车
      this.__choosedSize.clear(); // 清除已选中
      Ycn.toast('添加成功');
    } else {
      Ycn.toast('还没有选择尺寸');
    }
  }

  // 点击立即购买
  void _buy() {
    if (this.__choosedSize.choosedTotal > 0) {
      Navigator.of(context).pushNamed('/confirm-order', arguments: {
        'from': 'detail',
        'goodLsit': clearShopCarListNumZero([beforeAddToShopCar(Ycn.clone(this._data), Ycn.clone(this.__choosedSize.choosedList))]),
      });
    } else {
      Ycn.toast('还没有选择尺寸');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._data == null) {
      this._request({'id': (ModalRoute.of(context).settings.arguments as Map)['id']}); // 请求数据
    }

    return Consumer2(
      builder: (BuildContext context, ProviderShopCar shopCar, ProviderChoosedSize choosed, Widget child) {
        this.__shopCar = shopCar;
        this.__choosedSize = choosed;
        return Loading(
          loading: this._loading,
          child: Scaffold(
            appBar: Ycn.appBar(context, title: '商品详情'),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: Ycn.px(400),
                          color: Colors.white,
                          child: this._data == null
                              ? null
                              : Swiper(
                                  index: 0,
                                  duration: 345,
                                  autoplay: true,
                                  viewportFraction: 0.999999,
                                  itemCount: this._data['imgList'].length,
                                  itemBuilder: (context, index) => Image.network(
                                    this._data['imgList'][index],
                                    width: Ycn.px(750),
                                    height: Ycn.px(250),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Container(
                          height: Ycn.px(134),
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: Ycn.px(1)),
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: Ycn.px(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(Ycn.waitString(this._data, 'name'), style: TextStyle(fontSize: Ycn.px(32))),
                              Row(
                                children: <Widget>[
                                  Text('进货价：￥${Ycn.waitString(this._data, 'price')}.00',
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(26))),
                                  SizedBox(width: Ycn.px(30)),
                                  Text('我的库存：${(ModalRoute.of(context).settings.arguments as Map)['storage']}件',
                                      style: TextStyle(fontSize: Ycn.px(26))),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: Ycn.px(90),
                            margin: EdgeInsets.only(bottom: Ycn.px(10)),
                            child: Material(
                              color: Colors.white,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pushNamed('/choose-size'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(width: Ycn.px(30)),
                                    Text('选择尺寸', style: TextStyle(fontSize: Ycn.px(26))),
                                    SizedBox(width: Ycn.px(30)),
                                    Expanded(
                                      child: ListView(
                                        padding: EdgeInsets.symmetric(vertical: Ycn.px(23)),
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          ...this.__choosedSize.choosedSizeTotal.map((item) {
                                            return item['num'] > 0
                                                ? Stack(
                                                    overflow: Overflow.visible,
                                                    children: <Widget>[
                                                      Container(
                                                        width: Ycn.px(88),
                                                        alignment: Alignment(0, 0),
                                                        margin: EdgeInsets.symmetric(horizontal: Ycn.px(10)),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(Ycn.px(4)),
                                                          border: Border.all(width: Ycn.px(2), color: Theme.of(context).textTheme.body1.color),
                                                        ),
                                                        child: Text(item['size'], style: TextStyle(fontSize: Ycn.px(26))),
                                                      ),
                                                      Positioned(top: Ycn.px(-18), right: Ycn.px(0), child: RedDot(number: item['num']))
                                                    ],
                                                  )
                                                : Container(width: 0, height: 0);
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: Ycn.px(30)),
                                    Icon(Icons.arrow_forward_ios, size: Ycn.px(30), color: Theme.of(context).textTheme.display1.color),
                                    SizedBox(width: Ycn.px(30)),
                                  ],
                                ),
                              ),
                            )),
                        Container(
                          height: Ycn.px(90),
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: Ycn.px(1)),
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: Ycn.px(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('数量', style: TextStyle(fontSize: Ycn.px(26))),
                              Text('${this.__choosedSize.choosedTotal} 件', style: TextStyle(fontSize: Ycn.px(26))),
                            ],
                          ),
                        ),
                        Container(
                          height: Ycn.px(90),
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: Ycn.px(1)),
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: Ycn.px(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('总计金额', style: TextStyle(fontSize: Ycn.px(26))),
                              Text(
                                '￥${Ycn.numDot(
                                  this.__choosedSize.choosedTotal * (this._data == null ? 0 : this._data['price']),
                                )}.00',
                                style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(26)),
                              ),
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialInkWell(
                          onTap: () => Navigator.of(context).pushNamed('/shop-car'),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.shopping_cart, size: Ycn.px(48), color: Theme.of(context).accentColor),
                                    SizedBox(width: Ycn.px(9)),
                                    Text('购物车', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(32))),
                                  ],
                                ),
                              ),
                              Positioned(top: Ycn.px(4), left: Ycn.px(176), child: RedDot(number: this.__shopCar.totalNum))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: MaterialInkWell(
                          onTap: this._addShopCar,
                          child: Container(
                            alignment: Alignment(0, 0),
                            color: Ycn.getColor('#FFA94C'),
                            child: Text('加入购物车', style: TextStyle(color: Colors.white, fontSize: Ycn.px(32))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MaterialInkWell(
                          onTap: this._buy,
                          child: Container(
                            alignment: Alignment(0, 0),
                            color: Theme.of(context).accentColor,
                            child: Text('立即购买', style: TextStyle(color: Colors.white, fontSize: Ycn.px(32))),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
