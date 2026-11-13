enum DriverApprovalStatus {
  pending,
  underReview,
  approved,
  rejected
}

class DriverModel {
  const DriverModel({
    required this.id,
    required this.userId,
    required this.idCardUrl,
    required this.criminalRecordUrl,
    required this.drivingLicenseUrl,
    required this.carType,
    required this.carModel,
    required this.carColor,
    required this.licensePlate,
    required this.approvalStatus,
    required this.driverRating,
    required this.totalRides,
    this.approvedAt
  });

  final String id;
  final String userId;

  // Driver documents
  final String idCardUrl;
  final String criminalRecordUrl;
  final String drivingLicenseUrl;

  // Car information
  final String carType;
  final String carModel;
  final String carColor;
  final String licensePlate;

  // Driver status and statistics
  final DriverApprovalStatus approvalStatus;
  final double driverRating;
  final int totalRides;
  final DateTime? approvedAt;
}