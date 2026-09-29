import 'package:flutter/material.dart';
import 'package:ride_share/core/models/user_model.dart';

enum UserMode { rider, driver }

class AuthProvider extends ChangeNotifier {
  // Account state.
  String? _email;
  String? _fullName;
  String? _phone;
  DateTime? _sinceDate;
  bool _canBecomeDriver = false;
  UserModel? _user;

  // Active app mode.
  UserMode _currentMode = UserMode.rider;

  // Account state accessors.
  bool? get canBecomeDriver => _canBecomeDriver;
  DateTime? get sinceDate => _sinceDate;
  UserModel? get getUser => _user;
  String? get userEmail => _email;
  String? get userFullName => _fullName;
  String? get userPhone => _phone;

  // Account state updates.
  set setCanBecomeDriver(bool value) {
    _canBecomeDriver = value;
    notifyListeners();
  }

  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  set setUserAccCreatedAtDate(DateTime date) {
    _sinceDate = date;
    notifyListeners();
  }

  set setUserEmail(String email) {
    _email = email;
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

  // Active app mode accessors and updates.
  UserMode get currentUserMode => _currentMode;
  set setMode(UserMode userMode) {
    _currentMode = userMode;
    notifyListeners();
  }
}
