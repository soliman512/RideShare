import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestGalleryPermission() async {
    Permission permission;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      permission = androidInfo.version.sdkInt >= 33
          ? Permission.photos
          : Permission.storage;
    } else if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      return false;
    }

    return _checkAndRequest(permission);
  }

  // Shared permission handler
  static Future<bool> _checkAndRequest(Permission permission) async {
    var status = await permission.status;

    // Permission already granted
    if (status.isGranted || status.isLimited) {
      return true;
    }

    // Request permission
    if (status.isDenied) {
      status = await permission.request();
    }

    // Check result
    if (status.isGranted || status.isLimited) {
      return true;
    }

    // Permission permanently denied or restricted
    if (status.isPermanentlyDenied || status.isRestricted) {
      return false;
    }

    return false;
  }
}
