import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/EventBus.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageRegisterExamine extends StatefulWidget {
  PageRegisterExamine({Key key}) : super(key: key);

  @override
  _PageRegisterExamineState createState() => _PageRegisterExamineState();
}

class _PageRegisterExamineState extends State<PageRegisterExamine> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  Map _pageData = {
    'index': 0,
    'page': [1, 1],
    'data': [[], []],
    'requesting': [false, false],
    'navs': ['我的邀请', '我的下级'],
    'apis': [apiExamineList1, apiExamineList2],
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

    EventBus().on('INVITE_EXAMINE_REJECT', (data) {
      setState(() {
        this._pageData['data'][0][data[0]]['intive_status'] = 2;
        this._pageData['data'][0][data[0]]['intive_cause'] = data[1];
      });
    });
    EventBus().on('UP_EXAMINE_REJECT', (data) {
      setState(() {
        this._pageData['data'][1][data[0]]['up_status'] = 2;
        this._pageData['data'][1][data[0]]['up_cause'] = data[1];
      });
    });
    EventBus().on('INVITE_EXAMINE_PASS', (index) {
      setState(() {
        this._pageData['data'][0][index]['intive_status'] = 1;
      });
    });
    EventBus().on('UP_EXAMINE_PASS', (index) {
      setState(() {
        this._pageData['data'][1][index]['up_status'] = 1;
      });
    });

    this._request(); // 发送网络请求
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '注册审核'),
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
                          itemBuilder: (BuildContext context, int index) => ExamineListItemWrapper(
                            index: index,
                            name: this._pageData['data'].indexOf(item) == 0 ? '我的邀请' : '我的下级',
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

class ExamineListItemWrapper extends StatelessWidget {
  final index, data, last, page, name;
  const ExamineListItemWrapper({Key key, this.index, this.data, this.last, this.page, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              ExamineListItem(name: name, index: index, data: data),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(child: Text(this.page == 0 ? '没有更多了' : '加载中...', style: TextStyle(fontSize: Ycn.px(28)))),
              ),
            ],
          )
        : ExamineListItem(name: name, index: index, data: data);
  }
}

class ExamineListItem extends StatelessWidget {
  final index, data, name;
  const ExamineListItem({Key key, this.index, this.data, this.name}) : super(key: key);

  String get examineStatus {
    if (this.name == '我的邀请') {
      if (this.data['intive_status'].toString() == '0') {
        return '待审核';
      } else if (this.data['intive_status'].toString() == '1') {
        if (this.data['up_status'].toString() == '0') {
          return '已通过 -> 等待上级审核';
        } else if (this.data['up_status'].toString() == '1') {
          return '已通过 -> 上级已通过';
        } else if (this.data['up_status'].toString() == '2') {
          return '上级未通过';
        }
      } else if (this.data['intive_status'].toString() == '2') {
        return '未通过';
      }
    } else if (this.name == '我的下级') {
      if (this.data['up_status'].toString() == '0') {
        return '待审核';
      } else if (this.data['up_status'].toString() == '1') {
        return '已通过';
      } else if (this.data['up_status'].toString() == '2') {
        return '未通过';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Ycn.px(10)),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: Ycn.px(180),
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.all(Ycn.px(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('申请人：${this.data['apply_name']}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                    Row(
                      children: <Widget>[
                        Icon(Icons.event_note, size: Ycn.px(30), color: Theme.of(context).accentColor),
                        SizedBox(width: Ycn.px(26)),
                        Text(
                          '邀请人：${this.data['invite_name']}',
                          style: TextStyle(height: 1.25, fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.query_builder, size: Ycn.px(30), color: Theme.of(context).accentColor),
                        SizedBox(width: Ycn.px(26)),
                        Text(
                          '申请时间：${this.data['apply_time']}',
                          style: TextStyle(height: 1.25, fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Ycn.px(1)),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('状态：', style: TextStyle(fontSize: Ycn.px(32))),
                              Text(
                                '${this.examineStatus}',
                                style: TextStyle(
                                    color:
                                        this.examineStatus == '待审核' ? Theme.of(context).accentColor : Theme.of(context).textTheme.display1.color,
                                    fontSize: Ycn.px(32)),
                              ),
                            ],
                          ),
                          SizedBox(width: Ycn.px(24)),
                          Expanded(
                            child: this.data['intive_status'].toString() == '2' || this.data['up_status'].toString() == '2'
                                ? Row(
                                    children: <Widget>[
                                      Text('驳回原因：', style: TextStyle(fontSize: Ycn.px(26))),
                                      Expanded(
                                        child: Text(
                                          this.data['intive_cause'].toString().isEmpty ? this.data['up_cause'] : this.data['intive_cause'],
                                          style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(width: 0, height: 0),
                          )
                        ],
                      ),
                    ),
                    (this.name == '我的邀请' && this.data['intive_status'].toString() == '0') ||
                            (this.name == '我的下级' && this.data['up_status'].toString() == '0')
                        ? Container(
                            width: Ycn.px(132),
                            height: Ycn.px(48),
                            decoration: BoxDecoration(border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor)),
                            child: FlatButton(
                              onPressed: () => Navigator.of(context).pushNamed('/examine-detail', arguments: {
                                'name': this.name,
                                'index': this.index,
                                'data': this.data,
                                'status': this.examineStatus,
                              }),
                              padding: EdgeInsets.all(0),
                              child: Text('去审核', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                            ),
                          )
                        : Container(width: 0, height: 0),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: Ycn.px(20),
            right: Ycn.px(30),
            child: [0].map((e) {
              if (this.data['intive_status'].toString() == '1' && this.data['up_status'].toString() == '1') {
                return Image.asset('lib/images/public/pass.png', width: Ycn.px(85), height: Ycn.px(58));
              } else if (this.data['intive_status'].toString() == '2' || this.data['up_status'].toString() == '2') {
                return Image.asset('lib/images/public/nopass.png', width: Ycn.px(85), height: Ycn.px(58));
              } else {
                return Container(width: 0, height: 0);
              }
            }).toList()[0],
          )
        ],
      ),
    );
  }
}
