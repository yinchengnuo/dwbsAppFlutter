import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/apis/order.dart';

class PageMyStock extends StatefulWidget {
  PageMyStock({Key key}) : super(key: key);

  @override
  _PageMyStockState createState() => _PageMyStockState();
}

class _PageMyStockState extends State<PageMyStock> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List _data;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    apiMyStck().then((status) {
      setState(() {
        print(this._data);
        this._data = status.data['data']['list'];
        this._tabController = TabController(initialIndex: 0, length: this._data.length, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '我的库存'),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: Ycn.px(84),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      isScrollable: true,
                      indicatorWeight: Ycn.px(6),
                      controller: this._tabController,
                      indicatorPadding: EdgeInsets.fromLTRB(Ycn.px(14), 0, Ycn.px(14), 0),
                      tabs: [
                        ...this
                            ._data
                            .map(
                              (item) => Tab(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: Ycn.px(250)),
                                  child: Container(margin: EdgeInsets.symmetric(horizontal: Ycn.px(25)), child: Text(item['name'])),
                                ),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: this._tabController,
                    children: [
                      ...this
                          ._data
                          .map(
                            (item) => SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: Ycn.px(180),
                                    color: Colors.white,
                                    margin: EdgeInsets.only(top: Ycn.px(10)),
                                    padding: EdgeInsets.symmetric(vertical: Ycn.px(20), horizontal: Ycn.px(30)),
                                    child: Row(
                                      children: <Widget>[
                                        Image.network(item['img'], width: Ycn.px(140), height: Ycn.px(140), fit: BoxFit.cover),
                                        SizedBox(width: Ycn.px(40)),
                                        Text(item['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: Ycn.px(90),
                                    color: Colors.white,
                                    margin: EdgeInsets.only(top: Ycn.px(10)),
                                    padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('单品价', style: TextStyle(fontSize: Ycn.px(32))),
                                        Text('￥${item['price']}', style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                      ],
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
                                        Text('库存剩余', style: TextStyle(fontSize: Ycn.px(32))),
                                        Text(
                                            '${item['typeList'].fold(0, (t, e) => t + e['num'].fold(t, (tt, ee) => tt + int.parse(ee.toString())))}件',
                                            style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                      ],
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
                                        Text('库存价值', style: TextStyle(fontSize: Ycn.px(32))),
                                        Text(
                                            '￥${item['price'] * item['typeList'].fold(0, (t, e) => t + e['num'].fold(t, (tt, ee) => tt + int.parse(ee.toString())))}',
                                            style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor)),
                                      ],
                                    ),
                                  ),
                                  item['typeList'].fold(0, (t, e) => t + e['num'].fold(t, (tt, ee) => tt + int.parse(ee.toString()))) == 0
                                      ? Container(width: 0, height: 0)
                                      : Container(
                                          margin: EdgeInsets.only(top: Ycn.px(10)),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: Ycn.px(60),
                                                color: Colors.white,
                                                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                                child: Row(children: <Widget>[Text('商品类型', style: TextStyle(fontSize: Ycn.px(26)))]),
                                              ),
                                              ...item['typeList']
                                                  .map(
                                                    (typeItem) => typeItem['num'].fold(0, (t, e) => t + int.parse(e.toString())) == 0
                                                        ? Container(width: 0, height: 0)
                                                        : Container(
                                                            height: Ycn.px(90),
                                                            color: Colors.white,
                                                            margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                            padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                Text(typeItem['name'], style: TextStyle(fontSize: Ycn.px(32))),
                                                                Text(
                                                                  '${typeItem['num'].fold(0, (t, e) => t + int.parse(e.toString()))}件',
                                                                  style: TextStyle(fontSize: Ycn.px(32), color: Theme.of(context).accentColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                  )
                                                  .toList(),
                                              SizedBox(height: Ycn.px(10))
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
                ),
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
