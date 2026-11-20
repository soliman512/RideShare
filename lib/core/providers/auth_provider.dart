import 'package:flutter/material.dart';
import 'package:ride_share/core/models/user_model.dart';
import 'package:ride_share/core/supabase_services/auth_services.dart';

enum UserMode { rider, driver }

class AuthProvider extends ChangeNotifier {
  // ==================== User Data ====================
  UserModel? _user;
  String? _userEmail;

  // ==================== Account State ====================
  UserMode _currentMode = UserMode.rider;

  // ==================== Getters ====================
  UserModel? get user => _user;
  String? get userEmail => _userEmail;
  UserMode get currentUserMode => _currentMode;

  // ==================== User Data Operations ====================
  Future<void> loadUser() async {
    _user = await AuthServices.getCurrentUserData();

    notifyListeners();
  }

  // ==================== Account State Updates ====================
  set setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  // ==================== App Mode ====================
  set setMode(UserMode userMode) {
    _currentMode = userMode;
    notifyListeners();
  }
}
