import '../../../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class IndexSwiperArea extends StatelessWidget {
  final swiperList, newList;
  const IndexSwiperArea({Key key, this.swiperList, this.newList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Ycn.px(300),
      margin: EdgeInsets.only(bottom: Ycn.px(12)),
      child: Column(
        children: <Widget>[
          Container(
            height: Ycn.px(250),
            color: Colors.white,
            child: Swiper(
              index: 0,
              duration: 345,
              autoplay: true,
              viewportFraction: 0.999999,
              itemCount: swiperList.length,
              itemBuilder: (BuildContext context, int index) => FlatButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  onPressed: () {
                    print('点击了第${index + 1}张图片');
                  },
                  child: Image.network(swiperList[index]['imgurl'], width: Ycn.px(750), height: Ycn.px(250), fit: BoxFit.cover)),
            ),
          ),
          Container(
            color: Colors.white,
            height: Ycn.px(50),
            padding: EdgeInsets.fromLTRB(Ycn.px(30), 0, Ycn.px(30), 0),
            child: Row(
              children: <Widget>[
                Image.asset('lib/images/home/index/index-news.png', width: Ycn.px(185), height: Ycn.px(29)),
                Container(
                  width: Ycn.px(72),
                  height: Ycn.px(36),
                  alignment: Alignment(0, 0),
                  margin: EdgeInsets.fromLTRB(Ycn.px(10), 0, Ycn.px(10), 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(Ycn.px(4))),
                    border: Border.all(color: Theme.of(context).accentColor, width: Ycn.px(1)),
                  ),
                  child: Text('热点', style: TextStyle(fontSize: Ycn.px(24), color: Theme.of(context).accentColor)),
                ),
                Expanded(
                  child: Swiper(
                    index: 0,
                    duration: 567,
                    autoplay: true,
                    itemCount: newList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) => Container(
                      alignment: Alignment(-1, 0),
                      child:
                          Text(newList[index]['contents'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Ycn.px(26))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
