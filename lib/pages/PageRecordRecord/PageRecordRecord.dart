import 'package:dwbs_app_flutter/apis/forturn.dart';
import 'package:dwbs_app_flutter/pages/PageHome/TabData/components/DataCard.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageRecordRecord extends StatefulWidget {
  PageRecordRecord({Key key}) : super(key: key);

  @override
  _PageRecordRecordState createState() => _PageRecordRecordState();
}

class _PageRecordRecordState extends State<PageRecordRecord> {
  Map _data;
  int _page = 1;
  bool _requesting = false;
  ScrollController _scrollController = ScrollController();

  // 请求数据方法
  void _request() async {
    if (!this._requesting && this._page != 0) {
      setState(() => this._requesting = true);
      final res = (await apiRecordOrderRecord({'page': this._page})).data;
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
      setState(() => this._requesting = false);
    }
  }

  // 触发下拉刷新
  Future _pageRefresh() async {
    setState(() => this._page = 1);
    await this._request();
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
      appBar: Ycn.appBar(context, title: '历史记录'),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                DataCard(title: '零售总收入(元）', content: '${this._data['all_money']}元'),
                Container(
                  height: Ycn.px(60),
                  color: Colors.white,
                  alignment: Alignment(-1, 0),
                  padding: EdgeInsets.only(left: Ycn.px(30)),
                  child: Text('交易明细', style: TextStyle(fontSize: Ycn.px(32), height: 1.25)),
                ),
                SizedBox(height: Ycn.px(1)),
                Expanded(
                  child: this._data['list'].length == 0
                      ? Center(child: Text('空空如也...'))
                      : RefreshIndicator(
                          onRefresh: this._pageRefresh,
                          child: ListView.separated(
                            itemCount: this._data['list'].length,
                            controller: this._scrollController,
                            itemBuilder: (context, index) => IncomeRunningListItemWrapper(
                              page: this._page,
                              data: this._data['list'][index],
                              last: index == this._data['list'].length - 1,
                            ),
                            separatorBuilder: (context, index) => Container(height: Ycn.px(1)),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class IncomeRunningListItemWrapper extends StatelessWidget {
  final data, last, page;
  const IncomeRunningListItemWrapper({Key key, this.data, this.last, this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              IncomeRunningListItem(data: data),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(child: Text(this.page == 0 ? '没有更多了' : '加载中...', style: TextStyle(fontSize: Ycn.px(28)))),
              ),
            ],
          )
        : IncomeRunningListItem(data: data);
  }
}

class IncomeRunningListItem extends StatelessWidget {
  final data;
  const IncomeRunningListItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(90),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: Ycn.px(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${Ycn.formatIncomeType(this.data['type'])}', style: TextStyle(fontSize: Ycn.px(26))),
              SizedBox(height: Ycn.px(10)),
              Text('${this.data['created_at']}', style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).textTheme.display1.color)),
            ],
          ),
          Text('+${this.data['money']}', style: TextStyle(fontSize: Ycn.px(30), color: Theme.of(context).accentColor)),
        ],
      ),
    );
  }
}
