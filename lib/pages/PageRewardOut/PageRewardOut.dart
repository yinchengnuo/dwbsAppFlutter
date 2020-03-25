import 'package:dwbs_app_flutter/apis/forturn.dart';
import 'package:dwbs_app_flutter/common/components.dart';
import 'package:dwbs_app_flutter/pages/PageHome/TabData/components/DataCard.dart';

import '../../common/Ycn.dart';
import 'package:flutter/material.dart';

class PageRewardOut extends StatefulWidget {
  PageRewardOut({Key key}) : super(key: key);

  @override
  _PageRewardOutState createState() => _PageRewardOutState();
}

class _PageRewardOutState extends State<PageRewardOut> {
  Map _data;
  bool _loading = false;
  DateTime _date = DateTime.now();

  String get timeStamp => (int.parse(_date.millisecondsSinceEpoch.toString()) / 1000).floor().toString();

  String get date {
    String date = this._date.toString().split(' ')[0];
    String year = date.split('-')[0];
    String month = date.split('-')[1];
    String day = date.split('-')[2];
    return '${year}年${month}月${day}日';
  }

  // 请求数据
  void _request() {
    if (this._data != null) {
      setState(() {
        this._loading = true;
      });
    }
    apiRewardDetail({'type': 0}).then((status) {
      setState(() {
        this._data = status.data['data'];
      });
    }).whenComplete(() {
      setState(() {
        this._loading = false;
      });
    });
  }

  // 选择日期
  void _chooseDate() async {
    showDatePicker(context: context, initialDate: this._date, firstDate: DateTime(2014), lastDate: DateTime.now()).then((res) {
      if (res != null && res.toString().split(' ')[0] != this._date.toString().split(' ')[0]) {
        setState(() {
          this._date = res;
          this._request();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._request();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '奖励支出'),
        body: this._data == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DataCard(title: '已收入(元）', content: '${this._data['all_money']}元'),
                    Column(
                      children: <Widget>[
                        Container(
                          height: Ycn.px(76),
                          color: Colors.white,
                          alignment: Alignment(0, 0),
                          child: MaterialInkWell(
                            onTap: this._chooseDate,
                            child: Center(child: Text('${this.date} >', style: TextStyle(fontSize: Ycn.px(32)))),
                          ),
                        ),
                        SizedBox(height: Ycn.px(1)),
                        Container(
                          height: Ycn.px(423),
                          color: Colors.white,
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: Ycn.px(320),
                            height: Ycn.px(320),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  value: this._data['money'] / this._data['all_money'],
                                  strokeWidth: Ycn.px(18),
                                  backgroundColor: Ycn.getColor('#FFB769'),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('收入金额（元）', style: TextStyle(fontSize: Ycn.px(26))),
                                    SizedBox(height: Ycn.px(24)),
                                    Text(
                                      '${this._data['all_money']}元',
                                      style: TextStyle(fontSize: Ycn.px(50), color: Theme.of(context).accentColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
