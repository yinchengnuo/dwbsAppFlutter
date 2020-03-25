import 'package:flutter/material.dart';
import '../../../../common/Ycn.dart'; // 引入工具库
import 'CommListItem.dart';

class CommListItemWrapper extends StatelessWidget {
  final data, last, page, type, index, provider;
  const CommListItemWrapper({Key key, this.data, this.last, this.page, this.type, this.index, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.last
        ? Column(
            children: <Widget>[
              CommListItem(data: data, type: type, index: index, provider: provider),
              Container(
                height: Ycn.px(90),
                color: Colors.white,
                child: Center(child: Text(this.page == 0 ? '没有更多了' : '加载中...', style: TextStyle(fontSize: Ycn.px(28)))),
              ),
            ],
          )
        : CommListItem(data: data, type: type, index: index, provider: provider);
  }
}
