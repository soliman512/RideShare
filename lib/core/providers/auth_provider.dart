import 'package:flutter/material.dart';
import 'package:ride_share/core/models/user_model.dart';

enum UserMode { rider, driver }

class AuthProvider extends ChangeNotifier {
  String? _email;
  String? _fullName;
  String? _phone;
  DateTime? _sinceDate;
  UserModel? _user;

  UserMode _currentMode = UserMode.rider;

  String? get userEmail => _email;
  DateTime? get sinceDate => _sinceDate;
  String? get userFullName => _fullName;
  String? get userPhone => _phone;

  UserModel? get getUser => _user;

  set setUserEmail(String email) {
    _email = email;
    notifyListeners();
  }
  set setUserAccCreatedAtDate(DateTime date) {
    _sinceDate = date;
    notifyListeners();
  }

  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  set setUserFullName(String fullName) {
    _fullName = fullName;
    notifyListeners();
  }

  set setUserPhoneNumber(String phoneNumber) {
    _phone = phoneNumber;
    notifyListeners();
  }

  UserMode get currentUserMode => _currentMode;
  set setMode(UserMode userMode) {
    _currentMode = userMode;
    notifyListeners();
  }
}
