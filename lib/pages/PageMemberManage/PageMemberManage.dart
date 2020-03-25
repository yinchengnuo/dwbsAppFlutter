import 'package:dwbs_app_flutter/common/components.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/apis/team.dart';

class PageMemberManage extends StatefulWidget {
  PageMemberManage({Key key}) : super(key: key);

  @override
  _PageMemberManageState createState() => _PageMemberManageState();
}

class _PageMemberManageState extends State<PageMemberManage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _requested = false;
  String _todayNew = '0';
  String _monthNew = '0';
  TabController _tabController;
  Map _pageData = {
    'index': 0,
    'page': [1, 1],
    'data': [[], []],
    'requesting': [false, false],
    'navs': ['直属代理', '下级代理'],
    'apis': [apiTeamList1, apiTeamList2],
    'controllers': [ScrollController(), ScrollController()],
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
      setState(() {
        this._pageData['requesting'][index] = false;
        this._requested = true;
        this._todayNew = res['data']['today_new'].toString();
        this._monthNew = res['data']['month_new'].toString();
      });
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

    this._request(); // 发送网络请求
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '团员管理'),
      body: !this._requested
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  height: Ycn.px(200),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(this._todayNew, style: TextStyle(fontSize: Ycn.px(50), color: Theme.of(context).accentColor)),
                                Text('人', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor, height: 1.8)),
                              ],
                            ),
                            SizedBox(height: Ycn.px(23)),
                            Text('今日新增代理', style: TextStyle(fontSize: Ycn.px(26))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(this._monthNew, style: TextStyle(fontSize: Ycn.px(50), color: Theme.of(context).accentColor)),
                                Text('人', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor, height: 1.8)),
                              ],
                            ),
                            SizedBox(height: Ycn.px(23)),
                            Text('本月新增代理', style: TextStyle(fontSize: Ycn.px(26))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Ycn.px(10)),
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
                SizedBox(height: Ycn.px(10)),
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
                                itemBuilder: (BuildContext context, int index) => TeamListItemWrapper(
                                  data: item[index],
                                  page: this._pageData['page'][this._pageData['data'].indexOf(item)],
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TeamListItemWrapper extends StatelessWidget {
  final data, last, page;
  const TeamListItemWrapper({Key key, this.data, this.last, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              TeamListItem(data: data),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(child: Text(this.page == 0 ? '没有更多了' : '加载中...', style: TextStyle(fontSize: Ycn.px(28)))),
              ),
            ],
          )
        : TeamListItem(data: data);
  }
}

class TeamListItem extends StatelessWidget {
  final data;
  const TeamListItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(90),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Ycn.px(1)),
      child: MaterialInkWell(
        onTap: () => Navigator.of(context).pushNamed(
          '/person-card',
          arguments: {'id': data['id'], 'self': false},
        ),
        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(Ycn.px(66)),
              child: Image.network(data['avatar'], width: Ycn.px(66), height: Ycn.px(66), fit: BoxFit.fill),
            ),
            SizedBox(width: Ycn.px(28)),
            Expanded(child: Text(data['nickname'], style: TextStyle(height: 1.25, fontSize: Ycn.px(32)), maxLines: 1, overflow: TextOverflow.ellipsis)),
            UserLevel(level: data['level']),
            SizedBox(width: Ycn.px(28)),
            Icon(Icons.arrow_forward_ios, size: Ycn.px(29), color: Ycn.getColor('#B7B7B7'))
          ],
        ),
      ),
    );
  }
}
