import '../../../apis/comm.dart';
import '../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/ProviderComm.dart';
import 'components/CommListItemWrapper.dart';

class TabComm extends StatefulWidget {
  TabComm({Key key}) : super(key: key);

  @override
  _TabCommState createState() => _TabCommState();
}

class _TabCommState extends State<TabComm> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ProviderComm __comm;
  TabController _tabController;
  Map _pageData = {
    'index': 0,
    'page': [1, 1, 1, 1],
    'data': [[], [], [], []],
    'requesting': [false, false, false, false],
    'navs': ['热门推荐', '最新更新', '常来微聊', '我的收藏'],
    'apis': [apiCommListRemen, apiCommListZuixin, apiCommListChanglai, apiCommListShoucang],
    'controllers': [ScrollController(), ScrollController(), ScrollController(), ScrollController()],
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
        this.__comm.upData(this._pageData['index'], res['data']['list']);
      } else {
        this.__comm.upData(this._pageData['index'], [...this.__comm.commList[index], ...res['data']['list']]);
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
    if (scrollController.position.maxScrollExtent / Ycn.screenW() * 750 - scrollController.offset / Ycn.screenW() * 750 <= 100) {
      this._request(); // 距离底部 <= 100rpx 发送网络请求
    }
  }

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: this._pageData['navs'].length, vsync: this);

    // 左右拖动改变 tabIndex
    this._tabController.addListener(() {
      if (!this._tabController.indexIsChanging) {
        this._pageData['index'] = this._tabController.index;
        if (this._pageData['page'][this._pageData['index']] != 0 && this.__comm.commList[this._pageData['index']].length == 0) {
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
    return Consumer(
      builder: (BuildContext context, ProviderComm comm, Widget child) {
        this.__comm = comm;
        return Scaffold(
          appBar: Ycn.appBar(context, back: false, title: '社区'),
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
                  children: this.__comm.commList.map(
                    (item) {
                      if (this._pageData['page'][this.__comm.commList.indexOf(item)] == 1 &&
                          this._pageData['requesting'][this.__comm.commList.indexOf(item)] &&
                          this.__comm.commList[this.__comm.commList.indexOf(item)].length == 0) {
                        return Center(child: CircularProgressIndicator());
                      } else if (this._pageData['page'][this.__comm.commList.indexOf(item)] == 0 &&
                          this.__comm.commList[this.__comm.commList.indexOf(item)].length == 0) {
                        return Center(child: Text('空空如也...'));
                      } else {
                        return RefreshIndicator(
                          onRefresh: this._pageRefresh,
                          child: ListView.builder(
                            controller: this._pageData['controllers'][this.__comm.commList.indexOf(item)],
                            itemCount: this.__comm.commList[this.__comm.commList.indexOf(item)].length,
                            itemBuilder: (BuildContext context, int index) => CommListItemWrapper(
                              index: index,
                              provider: this.__comm,
                              type: this._pageData['index'],
                              page: this._pageData['page'][this.__comm.commList.indexOf(item)],
                              data: this.__comm.commList[this.__comm.commList.indexOf(item)][index],
                              last: index == this.__comm.commList[this.__comm.commList.indexOf(item)].length - 1,
                            ),
                          ),
                        );
                      }
                    },
                  ).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
