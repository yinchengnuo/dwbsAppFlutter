import '../../../apis/app.dart'; // 引入接口
import '../../../common/Ycn.dart';
import 'components/DataCard.dart';
import 'components/DataTeam.dart';
import 'components/DataStock.dart';
import 'components/DataIncome.dart';
import 'components/DataTeamRank.dart';
import 'package:flutter/material.dart';
import '../../../common/components.dart';

class TabData extends StatefulWidget {
  TabData({Key key}) : super(key: key);

  @override
  _TabDataState createState() => _TabDataState();
}

class _TabDataState extends State<TabData> with AutomaticKeepAliveClientMixin {
  Map _dataData;

  // 触发下拉刷新
  Future<void> _pageRefresh() async {
    this._dataData = (await apiAppData()).data; // 发送网络请求
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
      appBar: Ycn.appBar(context, back: false, title: '数据'),
      body: this._dataData == null
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)))
          : RefreshIndicator(
              onRefresh: this._pageRefresh,
              child: ScrollConfiguration(
                  behavior: NoBehavior(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        DataCard(title: '累计业绩（元）', content: '${Ycn.numDot(this._dataData['data']['total_income'])}元'),
                        DataStock(data: this._dataData['data']),
                        DataIncome(data: this._dataData['data']),
                        DataTeam(data: this._dataData['data']),
                        this._dataData['data']['team_rank'].length == 0
                            ? Container(width: 0, height: 0)
                            : DataTeamRank(data: this._dataData['data']),
                      ],
                    ),
                  )),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
