import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';
import 'DataTitle.dart';

class DataTeam extends StatelessWidget {
  final data;
  const DataTeam({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(341),
      margin: EdgeInsets.only(bottom: Ycn.px(10)),
      child: Column(
        children: <Widget>[
          DataTitle(data: this.data, title: '本月新增团队成员', handle: () => print('点击了 => 本月新增团队成员 => 更多')),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(Ycn.px(60), Ycn.px(28), Ycn.px(60), 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: Ycn.px(198),
                    height: Ycn.px(198),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CircularProgressIndicator(
                          value: this.data['month_team_num'] / this.data['total_team_num'],
                          strokeWidth: 10,
                          backgroundColor: Color(int.parse('FFB769', radix: 16)).withAlpha(255),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('总人数', style: TextStyle(fontSize: Ycn.px(26))),
                            Text('${Ycn.numDot(this.data['total_team_num'])}人',
                                style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: Ycn.px(306),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('新增总数', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_team_num'])}人',
                                style: TextStyle(fontSize: Ycn.px(26), height: 2, color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('特级代理', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_super_num'])}人',
                                style: TextStyle(fontSize: Ycn.px(26), height: 2, color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('顶级代理', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_top_num'])}人',
                                style: TextStyle(fontSize: Ycn.px(26), height: 2, color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('直属下级', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_direct_num'])}人',
                                style: TextStyle(fontSize: Ycn.px(26), height: 2, color: Theme.of(context).accentColor)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
