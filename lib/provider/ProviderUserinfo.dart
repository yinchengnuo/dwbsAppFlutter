import 'package:flutter/material.dart';

class ProviderComm with ChangeNotifier {
  final Map _userinfo = Map();

  Map get userinfo => this._userinfo;

  void upData(data) {
    notifyListeners();
  }

  void thumb(type, index) {
    notifyListeners();
  }

  void collection(type, index) {
    notifyListeners();
  }
}
