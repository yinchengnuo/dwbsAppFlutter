import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/components.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageMyInvite extends StatefulWidget {
  PageMyInvite({Key key}) : super(key: key);

  @override
  _PageMyInviteState createState() => _PageMyInviteState();
}

class _PageMyInviteState extends State<PageMyInvite> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  Map _pageData = {
    'index': 0,
    'page': [1, 1],
    'data': [[], []],
    'requesting': [false, false],
    'navs': ['已激活', '未激活'],
    'apis': [apiMyInvite1, apiMyInvite2],
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
      appBar: Ycn.appBar(context, title: '我的邀请'),
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
                          itemBuilder: (BuildContext context, int index) => TeamListItemWrapper(
                            index: this._pageData['data'].indexOf(item),
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
  final index, data, last, page;
  const TeamListItemWrapper({Key key, this.index, this.data, this.last, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              TeamListItem(index: index, data: data),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(child: Text(this.page == 0 ? '没有更多了' : '加载中...', style: TextStyle(fontSize: Ycn.px(28)))),
              ),
            ],
          )
        : TeamListItem(index: index, data: data);
  }
}

class TeamListItem extends StatelessWidget {
  final index, data;
  const TeamListItem({Key key, this.index, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(120),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Ycn.px(1)),
      child: MaterialInkWell(
        onTap: this.index == 1
            ? null
            : () => Navigator.of(context).pushNamed(
                  '/person-card',
                  arguments: {'id': data['id'], 'self': false},
                ),
        padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(Ycn.px(100)),
              child: Image.network(data['avatar'], width: Ycn.px(100), height: Ycn.px(100), fit: BoxFit.fill),
            ),
            SizedBox(width: Ycn.px(28)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(data['nickname'],
                            style: TextStyle(fontSize: Ycn.px(32), height: 1.25), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      UserLevel(level: data['level']),
                    ],
                  ),
                  SizedBox(height: Ycn.px(12)),
                  Text('${data['created_at']}加入', style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.display1.color))
                ],
              ),
            ),
            SizedBox(width: Ycn.px(28)),
            Icon(Icons.arrow_forward_ios, size: Ycn.px(29), color: this.index == 1 ? Colors.white : Ycn.getColor('#B7B7B7'))
          ],
        ),
      ),
    );
  }
}
