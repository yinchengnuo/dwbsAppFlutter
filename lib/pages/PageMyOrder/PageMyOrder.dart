import '../../common/Ycn.dart';
import '../../apis/order.dart';
import '../../common/Storage.dart';
import '../../common/EventBus.dart';
import 'package:flutter/material.dart';
import 'components/OrderListItem.dart';
import 'package:dwbs_app_flutter/common/components.dart';

class PageMyOrder extends StatefulWidget {
  PageMyOrder({Key key}) : super(key: key);

  @override
  _PageMyOrderState createState() => _PageMyOrderState();
}

class _PageMyOrderState extends State<PageMyOrder> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _loading = false;
  TabController _tabController;
  Map _pageData = {
    'index': 0,
    'page': [1, 1, 1],
    'data': [[], [], []],
    'requesting': [false, false, false],
    'navs': ['待审核', '待收货', '已完成'],
    'apis': [apiMyOrder1, apiMyOrder2, apiMyOrder3],
    'controllers': [ScrollController(), ScrollController(), ScrollController()],
  };

  // 发送网络请求
  Future _request() async {
    final index = this._pageData['index'];
    final api = this._pageData['apis'][index];
    final page = this._pageData['page'][index];
    if (!this._pageData['requesting'][index] && this._pageData['page'][index] != 0) {
      setState(() => this._pageData['requesting'][index] = true);
      final res = (await api({'page': page})).data;
      if (page == 1) {
        this._pageData['data'][this._pageData['index']] = res['data']['list'];
      } else {
        this._pageData['data'][this._pageData['index']].addAll(res['data']['list']);
      }
      if (res['data']['list'].length < res['data']['size']) {
        setState(() => this._pageData['page'][index] = 0);
      } else {
        setState(() => this._pageData['page'][index]++);
      }
      setState(() => this._pageData['requesting'][index] = false);
    }
  }

  // 触发下拉刷新
  Future<void> _pageRefresh() async {
    setState(() => this._pageData['page'][this._pageData['index']] = 1);
    await this._request();
  }

  // 上拉触底加载
  void _scrollControllerListener(index) {
    ScrollController scrollController = this._pageData['controllers'][index]; // 获取控制器
    if (scrollController.position.maxScrollExtent / Ycn.screenW() * 750 - scrollController.offset / Ycn.screenW() * 750 <= 567) {
      this._request(); // 距离底部 <= 100rpx 发送网络请求
    }
  }

  @override
  void initState() {
    super.initState();
    if (!Storage.getter('ORDERTYPE').isEmpty) {
      this._pageData['index'] = int.parse(Storage.getter('ORDERTYPE'));
      Storage.del('ORDERTYPE');
    }

    this._tabController = TabController(initialIndex: this._pageData['index'], length: this._pageData['navs'].length, vsync: this);

    // 左右拖动改变 tabIndex
    this._tabController.addListener(() {
      if (!this._tabController.indexIsChanging) {
        this._pageData['index'] = this._tabController.index;
        if (this._pageData['page'][this._pageData['index']] != 0 && this._pageData['data'][this._pageData['index']].length == 0) {
          this._request();
        }
      }
    });

    // 为 tabbarView 中的控制器添加监听事件
    this._pageData['controllers'].forEach((item) {
      item.addListener(() => this._scrollControllerListener(this._pageData['controllers'].indexOf(item)));
    });

    EventBus().on('MY_ORDER_LOADING', (res) {
      setState(() {
        this._loading = true;
      });
    });
    EventBus().on('MY_ORDER_HIDELOADING', (res) {
      setState(() {
        this._loading = false;
      });
    });
    EventBus().on('RECEIVE_GOODS', (index) {
      setState(() {
        if (this._pageData['page'][2] != 1) {
          this._pageData['data'][2].insert(0, Ycn.clone(this._pageData['data'][1][index]));
        }
        this._pageData['data'][1].removeAt(index);
      });
      this._scrollControllerListener(this._pageData['index']);
      Ycn.toast('确认收货成功');
    });

    this._request(); // 发送网络请求
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '我的订单'),
        body: Column(
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
                  tabs: [...this._pageData['navs'].map((nav) => Tab(text: nav)).toList()],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: this._tabController,
                physics: ClampingScrollPhysics(),
                children: [
                  ...this._pageData['data'].map(
                    (item) {
                      if (this._pageData['page'][this._pageData['index']] == 1 &&
                          this._pageData['requesting'][this._pageData['index']] &&
                          this._pageData['data'][this._pageData['index']].length == 0) {
                        return Center(child: CircularProgressIndicator());
                      } else if (this._pageData['page'][this._pageData['data'].indexOf(item)] == 0 &&
                          this._pageData['data'][this._pageData['data'].indexOf(item)].length == 0) {
                        return Center(child: Text('空空如也...'));
                      } else {
                        return RefreshIndicator(
                          onRefresh: this._pageRefresh,
                          child: ListView.builder(
                            controller: this._pageData['controllers'][this._pageData['data'].indexOf(item)],
                            itemCount: this._pageData['data'][this._pageData['data'].indexOf(item)].length,
                            itemBuilder: (BuildContext context, int index) => OrderListItemWrapper(
                              index: index,
                              data: item[index],
                              page: this._pageData['page'][this._pageData['data'].indexOf(item)],
                              name: '我的订单' + this._pageData['navs'][this._pageData['data'].indexOf(item)],
                              last: index == this._pageData['data'][this._pageData['data'].indexOf(item)].length - 1,
                            ),
                          ),
                        );
                      }
                    },
                  ).toList()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
