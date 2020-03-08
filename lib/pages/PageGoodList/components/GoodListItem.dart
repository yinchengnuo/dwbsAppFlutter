import '../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import '../../../common/components.dart';

class GoodListItem extends StatelessWidget {
  final data;
  const GoodListItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Ycn.px(10)),
      child: MaterialInkWell(
        onTap: () => Navigator.of(context).pushNamed('/good-detail', arguments: {
          'id': this.data['id'].toString(),
          'storage': this.data['storage'].toString(),
        }),
        padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(16), Ycn.px(30), Ycn.px(24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.network(this.data['img'], width: Ycn.px(140), height: Ycn.px(140), fit: BoxFit.cover),
            SizedBox(width: Ycn.px(28)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this.data['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                  SizedBox(height: Ycn.px(14)),
                  Text('进货价：￥' + this.data['price'].toString(), style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '我的库存：' + this.data['storage'].toString(),
                        style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                      ),
                      Container(
                        width: Ycn.px(132),
                        height: Ycn.px(40),
                        alignment: Alignment(0, 0),
                        decoration: BoxDecoration(border: Border.all(width: Ycn.px(2), color: Theme.of(context).accentColor)),
                        child: Text('立即购买', style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor, height: 1.23)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
