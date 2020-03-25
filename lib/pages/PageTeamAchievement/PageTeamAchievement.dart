import 'package:city_pickers/city_pickers.dart';
import 'package:dwbs_app_flutter/apis/team.dart';
import 'package:dwbs_app_flutter/common/components.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageTeamAchievement extends StatefulWidget {
  PageTeamAchievement({Key key}) : super(key: key);

  @override
  _PageTeamAchievementState createState() => _PageTeamAchievementState();
}

class _PageTeamAchievementState extends State<PageTeamAchievement> {
  Map _data;
  int _page = 1;
  int _type = 0;
  int _time = 2;
  String _total = '0';
  String _typeName = '全部代理';
  String _timeName = '本月业绩';
  bool _requesting = false;
  ScrollController _scrollController = ScrollController();

  // 请求数据方法
  void _request() async {
    if (!this._requesting && this._page != 0) {
      setState(() => this._requesting = true);
      final res = (await apiTeamAchievement({'page': this._page, 'type': this._type, 'time': this._time})).data;
      if (this._page == 1) {
        this._data = res['data'];
      } else {
        this._data['list'].addAll(res['data']['list']);
      }
      if (res['data']['list'].length < res['data']['size']) {
        setState(() => this._page = 0);
      } else {
        setState(() => this._page++);
      }
      setState(() {
        this._requesting = false;
        this._total = res['data']['money'].toString();
      });
    }
  }

  // 触发下拉刷新
  Future _pageRefresh() async {
    setState(() => this._page = 1);
    await this._request();
  }

  // 选择代理类型
  void _chooseType() {
    Map<String, String> data = {
      '110000': '全部代理',
      '110001': '顶级代理',
      '110002': '特级代理',
    };
    CityPickers.showCityPicker(
      context: context,
      height: Ycn.px(567),
      itemExtent: Ycn.px(123),
      provincesData: data,
      showType: ShowType.p,
      barrierDismissible: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      confirmWidget: Container(child: Text('确定', style: TextStyle(fontSize: Ycn.px(38), color: Theme.of(context).accentColor))),
      cancelWidget: Container(child: Text('取消', style: TextStyle(fontSize: Ycn.px(38), color: Ycn.getColor('#AAAAAA')))),
    ).then((res) {
      if (res != null && res.provinceName != this._typeName) {
        setState(() {
          this._page = 1;
          this._total = '0';
          this._data['list'] = [];
          this._typeName = res.provinceName;
          this._type = int.parse(res.provinceId) - 110000;
          this._request();
        });
      }
    });
  }

  // 选择时长
  void _chooseTime() {
    Map<String, String> data = {
      '110000': '本日业绩',
      '110001': '本周业绩',
      '110002': '本月业绩',
    };
    CityPickers.showCityPicker(
      context: context,
      height: Ycn.px(567),
      itemExtent: Ycn.px(123),
      provincesData: data,
      showType: ShowType.p,
      barrierDismissible: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      confirmWidget: Container(child: Text('确定', style: TextStyle(fontSize: Ycn.px(38), color: Theme.of(context).accentColor))),
      cancelWidget: Container(child: Text('取消', style: TextStyle(fontSize: Ycn.px(38), color: Ycn.getColor('#AAAAAA')))),
    ).then((res) {
      if (res != null && res.provinceName != this._timeName) {
        print(res);
        setState(() {
          this._page = 1;
          this._total = '0';
          this._data['list'] = [];
          this._timeName = res.provinceName;
          this._time = int.parse(res.provinceId) - 110000;
          this._request();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._scrollController.addListener(() {
      if (this._scrollController.position.maxScrollExtent / Ycn.screenW() * 750 - this._scrollController.offset / Ycn.screenW() * 750 <= 123) {
        this._request(); // 距离底部 <= 100rpx 发送网络请求
      }
    });
    this._request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(context, title: '团队业绩'),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  height: Ycn.px(84),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialInkWell(
                          onTap: this._chooseType,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text(this._typeName, style: TextStyle(fontSize: Ycn.px(32))), Icon(Icons.expand_more)],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MaterialInkWell(
                          onTap: this._chooseTime,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text(this._timeName, style: TextStyle(fontSize: Ycn.px(32))), Icon(Icons.expand_more)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Ycn.px(10)),
                Container(
                  height: Ycn.px(90),
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('业绩合计', style: TextStyle(fontSize: Ycn.px(32))),
                      Text('￥${Ycn.numDot(this._total)}', style: TextStyle(color: Theme.of(context).accentColor, fontSize: Ycn.px(32))),
                    ],
                  ),
                ),
                SizedBox(height: Ycn.px(10)),
                Expanded(
                    child: [0].map((e) {
                  if (this._data['list'].length == 0 && this._page == 0) {
                    return Center(child: Text('空空如也...'));
                  } else if (this._data['list'].length == 0 && this._page == 1) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return RefreshIndicator(
                      onRefresh: this._pageRefresh,
                      child: ListView.separated(
                        itemCount: this._data['list'].length,
                        controller: this._scrollController,
                        itemBuilder: (context, index) => TeamAchievementListItemWrapper(
                          page: this._page,
                          data: this._data['list'][index],
                          last: index == this._data['list'].length - 1,
                        ),
                        separatorBuilder: (context, index) => Container(height: Ycn.px(1)),
                      ),
                    );
                  }
                }).toList()[0]),
              ],
            ),
    );
  }
}

class TeamAchievementListItemWrapper extends StatelessWidget {
  final data, last, page;
  const TeamAchievementListItemWrapper({Key key, this.data, this.last, this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              TeamAchievementListItem(data: data),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(child: Text(this.page == 0 ? '没有更多了' : '加载中...', style: TextStyle(fontSize: Ycn.px(28)))),
              ),
            ],
          )
        : TeamAchievementListItem(data: data);
  }
}

class TeamAchievementListItem extends StatelessWidget {
  final data;
  const TeamAchievementListItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(120),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(Ycn.px(100)),
            child: Image.network(this.data['avatar'], width: Ycn.px(100), fit: BoxFit.fill),
          ),
          SizedBox(width: Ycn.px(30)),
          Expanded(child: Text(data['nickname'], style: TextStyle(fontSize: Ycn.px(32)), maxLines: 1, overflow: TextOverflow.ellipsis)),
          UserLevel(level: data['level']),
          SizedBox(width: Ycn.px(30)),
          Text('￥${Ycn.numDot(this.data['money'])}', style: TextStyle(fontSize: Ycn.px(32))),
        ],
      ),
    );
  }
}
