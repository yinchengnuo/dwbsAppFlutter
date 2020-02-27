import 'package:flutter/material.dart';
import '../apis/comm.dart';

class ProviderComm with ChangeNotifier {
  final List<List> _commList = [[], [], [], []];

  List get commList => this._commList;
  
  void upData(index, data) {
    this._commList[index] = data;
    notifyListeners();
  }

  void thumb(type, index) {
    this._commList[type][index]['like'] = !this._commList[type][index]['like'];
    apiCommListItemAction({ 'type': 0, 'status': this._commList[type][index]['like'] ? 1 : 0, 'id': this._commList[type][index]['id'] });
    notifyListeners();
  }

  void collection(type, index) {
    this._commList[type][index]['collection'] = !this._commList[type][index]['collection'];
    apiCommListItemAction({ 'type': 1, 'status': this._commList[type][index]['collection'] ? 1 : 0, 'id': this._commList[type][index]['id'] });
    notifyListeners();
  }
  
}
