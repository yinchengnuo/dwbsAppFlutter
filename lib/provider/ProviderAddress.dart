import 'package:flutter/material.dart';

class ProviderAddress with ChangeNotifier {
  List _list;

  List get address => this._list;

  void init(list) {
    this._list = list;
    notifyListeners();
  }

  void add(item) {
    this._list.add(item);
    notifyListeners();
  }

  void del(index) {
    this._list.removeAt(index);
    notifyListeners();
  }

  void updata(item) {
    this._list[this._list.indexWhere((e) => e['id'] == item['id'])] = item;
    notifyListeners();
  }
}
