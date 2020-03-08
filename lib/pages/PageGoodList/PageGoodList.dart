import '../../apis/good.dart';
import '../../common/Ycn.dart';
import 'components/GoodListItem.dart';
import 'components/GoodGridItem.dart';
import 'package:flutter/material.dart';

class PageGoodList extends StatefulWidget {
  PageGoodList({Key key}) : super(key: key);

  @override
  _PageGoodListState createState() => _PageGoodListState();
}

class _PageGoodListState extends State<PageGoodList> {
  Map _data;
  String _viewType = 'list';

  // 切换显示模式
  void _switchViewType() {
    setState(() {
      this._viewType == 'list' ? this._viewType = 'gird' : this._viewType = 'list';
    });
  }

  // 点击商品
  void _toDetail(id) {}

  // 网路请求方法
  Future _request() async {
    final res = (await apiGoodList()).data;
    setState(() {
      this._data = res['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    this._request(); // 请求数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ycn.appBar(
        context,
        title: '订货下单',
        action: IconButton(
          icon: Icon(this._viewType == 'list' ? Icons.widgets : Icons.view_list, size: Ycn.px(36)),
          onPressed: this._switchViewType,
        ),
      ),
      body: this._data == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: this._request,
              child: this._viewType == 'list'
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemExtent: Ycn.px(180),
                      itemCount: this._data['list'].length,
                      itemBuilder: (context, index) => GoodListItem(data: this._data['list'][index]),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: Ycn.px(28), horizontal: Ycn.px(30)),
                      shrinkWrap: true,
                      itemCount: this._data['list'].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: Ycn.px(28),
                        crossAxisSpacing: Ycn.px(13),
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) => GoodGridItem(data: this._data['list'][index]),
                    ),
            ),
    );
  }
}
