import 'dart:core';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider extends ChangeNotifier{
  static String? _appName;
  static String? _appVersion;

   Future<void> initAppInfo() async {
    // debugPrint("===================================== ✅ getAppInfo() function has worked ✅ =====================================");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _appName = packageInfo.appName;
      _appVersion = packageInfo.version;

      notifyListeners();
  }
  String? get appName => _appName;
  String? get appVersion => _appVersion;
}