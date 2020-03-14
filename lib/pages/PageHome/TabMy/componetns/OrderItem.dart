import '../../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import '../../../../common/Storage.dart';

class OrderItem extends StatelessWidget {
  final onum, title, route, type;
  const OrderItem({Key key, this.onum, this.title, this.route, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Storage.setter('ORDERTYPE', this.type.toString());
            Navigator.of(context).pushNamed(this.route);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(this.onum.toString(), style: TextStyle(color: Ycn.getColor('#7B5533'), fontSize: Ycn.px(36))),
              Text(this.title, style: TextStyle(fontSize: Ycn.px(26))),
            ],
          ),
        ),
      ),
    );
  }
}
