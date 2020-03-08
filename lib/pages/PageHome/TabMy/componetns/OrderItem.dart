import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart';

class OrderItem extends StatelessWidget {
  final onum, title, route, arguments;
  const OrderItem({Key key, this.onum, this.title, this.route, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(this.route, arguments: this.arguments),
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
