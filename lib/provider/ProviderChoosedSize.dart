import 'package:flutter/material.dart';

class ProviderChoosedSize with ChangeNotifier {
  List _choosedList = [];

  List get choosedList => this._choosedList;

  List get choosedTypeTotal {
    List<int> choosedTypeNum = List();
    this._choosedList.forEach((item) {
      final int total = item['num'].reduce((t, e) => t + e);
      choosedTypeNum.add(total);
    });
    return choosedTypeNum;
  }

  List get choosedSizeTotal {
    List size = List();
    List sizeNum = List();
    this._choosedList.forEach((item) => size.addAll(item['size']));
    size.toSet().toList().forEach((size) {
      int numb = 0;
      this._choosedList.forEach((item) {
        numb += (item['size'].indexOf(size) == -1 ? 0 : item['num'][item['size'].indexOf(size)]);
      });
      sizeNum.add({'size': size, 'num': numb});
    });
    return sizeNum;
  }

  int get choosedTotal => this.choosedTypeTotal.fold(0, (t, e) => t + e);

  void init(typeList) {
    typeList.forEach((item) {
      item['num'] = List();
      item['size'].forEach((e) => item['num'].add(0));
    });
    this._choosedList = typeList;
    notifyListeners();
  }

  void change(type, size, number) {
    this._choosedList[type]['num'][size] = number;
    notifyListeners();
  }

  void clear() {
    this._choosedList.forEach((item) {
      item['num'] = List();
      item['size'].forEach((e) => item['num'].add(0));
    });
    notifyListeners();
  }
}
