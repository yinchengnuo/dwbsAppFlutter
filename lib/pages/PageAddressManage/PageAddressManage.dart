import '../../common/Ycn.dart';
import '../../apis/address.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ProviderAddress.dart';

class PageAddressManage extends StatefulWidget {
  PageAddressManage({Key key}) : super(key: key);

  @override
  _PageAddressManageState createState() => _PageAddressManageState();
}

class _PageAddressManageState extends State<PageAddressManage> {
  Function _choose;
  bool _loading = false;
  bool _requesting = false;
  ProviderAddress __address;

  // 请求地址
  Future _request() async {
    this.__address.init((await apiAddressGet()).data['data']['list']);
  }

  // 编辑地址
  void _edit(index) {
    Navigator.of(context).pushNamed('/edit-address', arguments: this.__address.address[index]).then((res) {
      if (res != null) {
        Ycn.toast('修改成功');
      }
    });
  }

  // 删除地址
  void _del(index) {
    Ycn.modal(context, content: ['确定删除这个地址？']).then((res) {
      if (res != null) {
        setState(() {
          this._loading = true;
        });
        apiAddressDel({'id': this.__address.address[index]['id']}).then((status) {
          this.__address.del(index);
        }).whenComplete(() {
          setState(() {
            this._loading = false;
          });
        });
      }
    });
  }

  // 新增地址
  void _add() {
    Navigator.of(context).pushNamed('/edit-address').then((res) {
      if (res != null) {
        Ycn.toast('新增成功');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ProviderAddress address, Widget child) {
      this.__address = address;
      if (this.__address.address == null) {
        this._request(); // 请求地址
      }
      return Loading(
        loading: this._loading,
        child: Scaffold(
          appBar: Ycn.appBar(context, title: '地址管理'),
          body: Column(
            children: <Widget>[
              Expanded(
                child: this.__address.address == null
                    ? Center(child: CircularProgressIndicator())
                    : this.__address.address.length == 0
                        ? Center(child: Text('还没有地址呢'))
                        : RefreshIndicator(
                            onRefresh: this._request,
                            child: ListView.builder(
                              itemCount: this.__address.address.length,
                              itemBuilder: (BuildContext context, int index) => ConstrainedBox(
                                constraints: BoxConstraints(minHeight: Ycn.px(234)),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: Ycn.px(10)),
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: (ModalRoute.of(context).settings.arguments as Map) == null
                                          ? null
                                          : () => Navigator.of(context).pop(this.__address.address[index]),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(Ycn.px(30), Ycn.px(40), Ycn.px(30), Ycn.px(0)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: Ycn.px(456)),
                                                  child: Text('收货人：${this.__address.address[index]['con_name']}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(height: 1.1, fontSize: Ycn.px(32))),
                                                ),
                                                Text('${this.__address.address[index]['con_mobile']}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Ycn.px(16),
                                            ),
                                            Text(
                                              '${Ycn.formatAddress(this.__address.address[index])}',
                                              style: TextStyle(height: 1.4, color: Theme.of(context).textTheme.display1.color),
                                            ),
                                            SizedBox(height: Ycn.px(16)),
                                            Divider(height: Ycn.px(1), color: Ycn.getColor('#D7D7D7')),
                                            Container(
                                              height: Ycn.px(74),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    height: double.infinity,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () => this._edit(index),
                                                        child: Row(
                                                          children: <Widget>[
                                                            SizedBox(width: Ycn.px(30)),
                                                            Icon(Icons.edit, size: Ycn.px(27), color: Ycn.getColor('#AAAAAA')),
                                                            SizedBox(width: Ycn.px(12)),
                                                            Text('编辑', style: TextStyle(fontSize: Ycn.px(24))),
                                                            SizedBox(width: Ycn.px(30)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: double.infinity,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () => this._del(index),
                                                        child: Row(
                                                          children: <Widget>[
                                                            SizedBox(width: Ycn.px(30)),
                                                            Icon(Icons.delete, size: Ycn.px(27), color: Ycn.getColor('#AAAAAA')),
                                                            SizedBox(width: Ycn.px(12)),
                                                            Text('删除', style: TextStyle(fontSize: Ycn.px(24))),
                                                            SizedBox(width: Ycn.px(30)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
              Container(
                height: Ycn.px(88),
                color: Theme.of(context).accentColor,
                child: MaterialInkWell(
                  onTap: () => this._add(),
                  child: Center(child: Text('新增地址', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34)))),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
