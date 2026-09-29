enum DriverApprovalStatus { pending, underReview, approved, rejected }

class DriverModel {
  const DriverModel({
    required this.id,
    required this.userId,
    required this.idCardUrl,
    required this.criminalRecordUrl,
    required this.approvalStatus,
    required this.driverRating,
    required this.totalRides,
    this.approvedAt,
  });

  final String id;
  final String userId;
  final String idCardUrl;
  final String criminalRecordUrl;
  final DriverApprovalStatus approvalStatus;
  final double driverRating;
  final int totalRides;
  final DateTime? approvedAt;
}
