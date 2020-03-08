import '../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import '../../../common/components.dart';

class GoodGridItem extends StatelessWidget {
  final data;
  const GoodGridItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Ycn.px(10)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: Ycn.px(14),
            offset: Offset(0, Ycn.px(10)),
            color: Ycn.getColor('#A8A8A8'),
          )
        ]),
        child: MaterialInkWell(
          onTap: () => Navigator.of(context).pushNamed('/good-detail', arguments: {
            'id': this.data['id'].toString(),
            'storage': this.data['storage'].toString(),
          }),
          child: Column(
            children: <Widget>[
              Image.network(this.data['img'], width: Ycn.px(338), height: Ycn.px(195), fit: BoxFit.cover),
              Expanded(
                  child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(18), Ycn.px(30), Ycn.px(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(this.data['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(32))),
                      Text(
                        '我的库存：' + this.data['storage'].toString(),
                        style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('￥' + this.data['price'].toString(),
                              style: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).accentColor)),
                          Container(
                            width: Ycn.px(126),
                            height: Ycn.px(40),
                            alignment: Alignment(0, 0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(Ycn.px(10)),
                            ),
                            child: Text('立即购买', style: TextStyle(fontSize: Ycn.px(22), color: Colors.white, height: 1.23)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
