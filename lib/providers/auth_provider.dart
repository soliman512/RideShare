import 'package:flutter/material.dart';

enum UserMode { rider, driver }

class AuthProvider extends ChangeNotifier {
  UserMode _currentMode = UserMode.rider;
  UserMode get currentUserMode => _currentMode;
  set setMode(UserMode userMode) {
    _currentMode = userMode;
    notifyListeners();
  }

  String get modeAsString => _currentMode.name;
}
