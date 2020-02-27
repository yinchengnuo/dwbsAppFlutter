import '../../../common/Ycn.dart';
import 'components/IndexTopItem.dart'; // 引入首页组件
import 'package:flutter/material.dart';
import '../../../common/components.dart';
import 'components/IndexSwiperArea.dart'; // 引入首页组件
import 'components/IndexKingkongItem.dart'; // 引入首页组件
import 'components/IndexBottomArtilce.dart'; // 引入首页组件

import '../../../apis/app.dart'; // 引入接口

class TabIndex extends StatefulWidget {
  TabIndex({Key key}) : super(key: key);

  @override
  _TabIndexState createState() => _TabIndexState();
}

class _TabIndexState extends State<TabIndex> with AutomaticKeepAliveClientMixin {
  Map _indexData; // 网络请数据

  // 点击首页右上角帮助
  _tapHelp(context) {
    Navigator.of(context).pushNamed('/how-to-use');
  }

  // 触发下拉刷新
  Future<void> _pageRefresh() async {
    this._indexData = (await apiAppIndex()).data; // 发送网络请求
    setState(() {}); // 渲染视图
  }

  @override
  void initState() {
    super.initState();
    this._pageRefresh(); // 触发下拉刷新，获取数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context,
          back: false, title: '首页', action: IconButton(icon: Icon(Icons.help_outline), onPressed: () => this._tapHelp(context))),
      body: this._indexData == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: this._pageRefresh,
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: Ycn.px(12)),
                        child: Row(
                          children: <Widget>[
                            IndexTopItem(src: 'lib/images/home/index/manage-order.png', title: '订货管理', route: '/manage-order'),
                            IndexTopItem(src: 'lib/images/home/index/manage-poeple.png', title: '人员管理', route: '/manage-team'),
                            IndexTopItem(src: 'lib/images/home/index/manage-fortune.png', title: '财富管理', route: '/manage-fortune'),
                          ],
                        ),
                      ),
                      IndexSwiperArea(swiperList: this._indexData['data']['swiper'], newList: this._indexData['data']['news']),
                      Container(
                        margin: EdgeInsets.only(bottom: Ycn.px(12)),
                        child: Wrap(
                          children: <Widget>[
                            IndexKingkongItem(src: 'lib/images/home/index/place-order.png', title: '订货下单', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/my-order.png', title: '我的订单', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/down-order.png', title: '下级订单', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/my-stock.png', title: '我的库存', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/invite-proxy.png', title: '邀请代理', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/register-examine.png', title: '注册审核', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/my-invite.png', title: '我的邀请', route: '/test'),
                            IndexKingkongItem(src: 'lib/images/home/index/team-manage.png', title: '团员管理', route: '/test'),
                          ],
                        ),
                      ),
                      IndexBottomArtilce(articleInfo: this._indexData['data']['article']),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
