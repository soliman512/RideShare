import 'package:flutter/material.dart';
import 'package:ride_share/core/models/driver_model.dart';

class DriverProfileProvider extends ChangeNotifier {
  // ==================== Driver Data ====================
  DriverProfileModel? _driver;
  DriverProfileModel? get driver => _driver;
  bool get hasDriverRequest => _driver != null;

  bool _canBecomeDriver = false;
  bool get canBecomeDriver => _canBecomeDriver;

  set setCanBecomeDriver(bool value) {
    _canBecomeDriver = value;
    notifyListeners();
  }

  set setDriverProfile(DriverProfileModel? profileModel) {
    _driver = profileModel;
    setCanBecomeDriver = _driver?.approvalStatus == .approved;
  }
  // ==================== Load Driver Profile ====================

  // ==================== Check Driver Approval Status ====================
  // Future<void> checkDriverStatus() async {
  //   try {
  //     _isCheckingStatus = true;
  //     _errorMessage = null;
  //     notifyListeners();

  //     final status = await DriverProfileServices.checkDriverStatus();

  //     if (status == DriverApprovalStatus.approved) {
  //       // Refresh the complete driver profile after approval.
  //       await loadDriverProfile();
  //     } else {
  //       // Update the status locally if your model supports copyWith.
  //       _driver = _driver?.copyWith(approvalStatus: status);
  //     }
  //   } catch (error) {
  //     _errorMessage = error.toString();
  //   } finally {
  //     _isCheckingStatus = false;
  //     notifyListeners();
  //   }
  // }
}
