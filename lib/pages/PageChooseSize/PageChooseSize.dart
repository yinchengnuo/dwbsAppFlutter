import '../../common/Ycn.dart';
import '../../common/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 引入 provider
import '../../provider/ProviderChoosedSize.dart';

class PageChooseSize extends StatefulWidget {
  PageChooseSize({Key key}) : super(key: key);

  @override
  _PageChooseSizeState createState() => _PageChooseSizeState();
}

class _PageChooseSizeState extends State<PageChooseSize> {
  int _typeIndex = 0;
  ProviderChoosedSize __choosed;
  PageController _pageController = PageController();

  void _switchType(index) {
    setState(() {
      this._typeIndex = index;
      this._pageController.animateToPage(index, duration: Duration(milliseconds: 888), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ProviderChoosedSize choosed, Widget child) {
        this.__choosed = choosed;
        return Scaffold(
          appBar: Ycn.appBar(context, title: '选择尺寸', action: AppBarTextAction(text: '确定', onTap: () => Navigator.of(context).pop())),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: Ycn.px(590),
                child: PageView(
                  scrollDirection: Axis.vertical,
                  children: [
                    ...this
                        .__choosed
                        .choosedList
                        .map(
                          (item) => SingleChildScrollView(
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: Ycn.px(60),
                                          color: Colors.white,
                                          alignment: Alignment(0, 0),
                                          margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                          child: Text(
                                            '尺码',
                                            style: TextStyle(
                                              fontSize: Ycn.px(26),
                                              color: Theme.of(context).textTheme.display1.color,
                                            ),
                                          ),
                                        ),
                                        ...item['size']
                                            .map(
                                              (size) => Container(
                                                height: Ycn.px(90),
                                                color: Colors.white,
                                                alignment: Alignment(0, 0),
                                                margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                child: Text(size, style: TextStyle(fontSize: Ycn.px(26))),
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: Ycn.px(60),
                                          color: Colors.white,
                                          alignment: Alignment(0, 0),
                                          margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                          child: Text(
                                            '数量',
                                            style: TextStyle(
                                              fontSize: Ycn.px(26),
                                              color: Theme.of(context).textTheme.display1.color,
                                            ),
                                          ),
                                        ),
                                        ...item['num']
                                            .asMap()
                                            .map(
                                              (index, value) => MapEntry(
                                                index,
                                                Container(
                                                  height: Ycn.px(90),
                                                  color: Colors.white,
                                                  alignment: Alignment(0, 0),
                                                  margin: EdgeInsets.only(bottom: Ycn.px(1)),
                                                  child: CustomCounter(
                                                    value: value,
                                                    onChange: (val) {
                                                      this.__choosed.change(this.__choosed.choosedList.indexOf(item), index, val);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                            .values
                                            .toList()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                  controller: this._pageController,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                width: Ycn.px(160),
                child: Container(
                  width: Ycn.px(160),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(offset: Offset(0, Ycn.px(3)), blurRadius: Ycn.px(7), color: Color.fromRGBO(0, 0, 0, 0.35))],
                  ),
                  child: Column(
                    children: <Widget>[
                      ChooseBarItem(
                          name: '共: ${this.__choosed.choosedList.length.toString()} 款', isTitle: true, number: this.__choosed.choosedTotal),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemExtent: Ycn.px(90),
                          itemCount: this.__choosed.choosedList.length,
                          itemBuilder: (context, index) => ChooseBarItem(
                            onTap: () => _switchType(index),
                            active: index == this._typeIndex,
                            number: this.__choosed.choosedTypeTotal[index],
                            name: this.__choosed.choosedList[index]['name'],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChooseBarItem extends StatelessWidget {
  final name, onTap, active, isTitle, number;
  const ChooseBarItem({Key key, this.name, this.onTap, this.active = false, this.isTitle = false, this.number = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(90),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: Ycn.px(1), color: Theme.of(context).scaffoldBackgroundColor)),
      ),
      child: MaterialInkWell(
        onTap: this.onTap,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                this.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Ycn.px(26),
                  color: this.isTitle
                      ? Theme.of(context).textTheme.body1.color
                      : this.active ? Theme.of(context).accentColor : Theme.of(context).textTheme.display1.color,
                ),
              ),
            ),
            Positioned(top: Ycn.px(8), right: Ycn.px(8), child: RedDot(number: this.number))
          ],
        ),
      ),
    );
  }
}
