import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';
import 'DataTitle.dart';

class DataIncome extends StatelessWidget {
  final data;
  const DataIncome({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(341),
      margin: EdgeInsets.only(bottom: Ycn.px(10)),
      child: Column(
        children: <Widget>[
          DataTitle(data: this.data, title: '本月营收情况', handle: () => Navigator.of(context).pushNamed('/income-running')),
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
                          value: this.data['month_income'] / this.data['total_income'],
                          strokeWidth: Ycn.px(18),
                          backgroundColor: Ycn.getColor('#FFB769'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('总业绩', style: TextStyle(fontSize: Ycn.px(26))),
                            Text('${Ycn.numDot(this.data['total_income'])}元',
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
                            Text('本月业绩', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_income'])}元',
                                style: TextStyle(fontSize: Ycn.px(26), height: 2, color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('本月收款', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_order_income'])}元',
                                style: TextStyle(fontSize: Ycn.px(26), height: 2, color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('零售收入', style: TextStyle(fontSize: Ycn.px(26), height: 2)),
                            Text('${Ycn.numDot(this.data['month_sold_income'])}元',
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
