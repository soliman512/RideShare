import 'package:flutter/material.dart';

class CurrentPageProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get getCurrentPage => _currentPage;
  set setCurrentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }
}
