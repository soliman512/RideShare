import 'package:flutter/material.dart';
import 'package:ride_share/core/models/user_model.dart';
import 'package:ride_share/core/supabase_services/auth_services.dart';

enum UserMode { rider, driver }

class AuthProvider extends ChangeNotifier {
  // Account state.
  bool _canBecomeDriver = false;
  // Active app mode.
  UserMode _currentMode = UserMode.rider;
  String? _userEmail;

  //-----------------------------
  UserModel? _user;

  UserModel? get user => _user;
  String? get userEmail => _userEmail;

  Future<void> loadUser() async {
    _user = await AuthServices.getCurrentUserData();

    notifyListeners();
  }
  //-----------------------------

  // Account state accessors.
  bool get canBecomeDriver => _canBecomeDriver;

  // Account state updates.
  set setCanBecomeDriver(bool value) {
    _canBecomeDriver = value;
    notifyListeners();
  }

  // Active app mode accessors and updates.
  UserMode get currentUserMode => _currentMode;
  set setMode(UserMode userMode) {
    _currentMode = userMode;
    notifyListeners();
  }
  set setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }
}
