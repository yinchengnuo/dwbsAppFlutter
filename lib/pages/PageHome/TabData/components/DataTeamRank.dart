import 'DataTitle.dart';
import '../../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import '../../../../common/components.dart';

class DataTeamRank extends StatelessWidget {
  final data;
  const DataTeamRank({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(364),
      margin: EdgeInsets.only(bottom: Ycn.px(24)),
      child: Column(
        children: <Widget>[
          DataTitle(data: this.data, title: '本月团队个人业绩排行榜', handle: () => print('点击了 => 本月团队个人业绩排行榜 => 更多')),
          ...this
              .data['team_rank']
              .map((item) => Container(
                    height: Ycn.px(90),
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: Ycn.px(1)),
                    padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(12), Ycn.px(30), Ycn.px(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(radius: Ycn.px(33), backgroundImage: NetworkImage(item['avatar'])),
                        SizedBox(width: Ycn.px(30)),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: Ycn.px(234)),
                                child: Text(
                                  item['nickname'], // 用户昵称
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: Ycn.px(32)),
                                ),
                              ),
                              UserLevel(level: item['level'])
                            ],
                          ),
                        ),
                        SizedBox(width: Ycn.px(30)),
                        Text(
                          '${Ycn.numDot(item['money'])}元',
                          style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor),
                        )
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
