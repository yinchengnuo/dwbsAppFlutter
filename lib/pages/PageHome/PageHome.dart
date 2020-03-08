import 'TabMy/TabMy.dart';
import 'TabComm/TabComm.dart';
import 'TabData/TabData.dart';
import 'TabIndex/TabIndex.dart';
import '../../common/Ycn.dart';
import '../../common/EventBus.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';

import '../../common/Storage.dart';

class PageHome extends StatefulWidget {
  PageHome({Key key}) : super(key: key);
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  PageController _pageController = PageController();
  List<Widget> _pageList = [TabIndex(), TabData(), TabComm(), TabMy()];

  final List _tabList = <Map>[
    {'title': '首页', 'icon': 'lib/images/home/tabbar/index.png', 'activeIcon': 'lib/images/home/tabbar/index-act.png'},
    {'title': '数据', 'icon': 'lib/images/home/tabbar/data.png', 'activeIcon': 'lib/images/home/tabbar/data-act.png'},
    {'title': '社区', 'icon': 'lib/images/home/tabbar/comm.png', 'activeIcon': 'lib/images/home/tabbar/comm-act.png'},
    {'title': '我的', 'icon': 'lib/images/home/tabbar/my.png', 'activeIcon': 'lib/images/home/tabbar/my-act.png'}
  ];

  int _activeIndex = 0;
  void _switchTab(index) {
    setState(() {
      this._activeIndex = index;
      this._pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('lib/images/home/tabbar/index.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/index-act.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/data.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/data-act.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/comm.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/comm-act.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/my.png'), context);
    precacheImage(AssetImage('lib/images/home/tabbar/my-act.png'), context);

    EventBus().on('RequestError', (arg) {
      print('监听到EventBus RequestError事件');
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
      Navigator.of(context).pushReplacementNamed('/login');
    });

    return Scaffold(
      body: PageView(
        children: this._pageList,
        controller: this._pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        height: Ycn.px(97),
        decoration: BoxDecoration(border: Border(top: BorderSide(width: Ycn.px(1), color: Color.fromRGBO(178, 178, 178, 0.1)))),
        child: Row(
          children: <Widget>[
            ...this
                ._tabList
                .map(
                  (item) => Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => this._switchTab(this._tabList.indexOf(item)),
                        child: this._tabList.indexOf(item) == 3
                            ? Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomBottomNavigationBarItem(
                                        item: item, index: this._tabList.indexOf(item), activeIndex: this._activeIndex),
                                  ),
                                  Positioned(top: Ycn.px(8), left: Ycn.px(98), child: RedDot(number: 999)),
                                ],
                              )
                            : CustomBottomNavigationBarItem(item: item, index: this._tabList.indexOf(item), activeIndex: this._activeIndex),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationBarItem extends StatelessWidget {
  final item, index, activeIndex;
  const CustomBottomNavigationBarItem({Key key, this.item, this.index, this.activeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        this.activeIndex == this.index
            ? ImageIcon(AssetImage(item['activeIcon']), size: Ycn.px(32), color: Theme.of(context).accentColor)
            : ImageIcon(AssetImage(item['icon']), size: Ycn.px(32), color: Theme.of(context).textTheme.body2.color),
        SizedBox(height: Ycn.px(8)),
        Text(
          item['title'],
          style: TextStyle(
            fontSize: Ycn.px(22),
            color: this.activeIndex == this.index ? Theme.of(context).accentColor : Theme.of(context).textTheme.body2.color,
          ),
        ),
      ],
    );
  }
}
