import 'package:ride_share/core/extension/driver_approval_status_extension.dart';

// enum DriverApprovalStatus {
//   pending,
//   underReview,
//   approved,
//   rejected
// }

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
    required this.createdAt,
    required this.updatedAt,
    this.carImages,
    this.rejectedReason,
    this.approvedAt,
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
  final List<String>? carImages;

  // Driver status and statistics
  final DriverApprovalStatus approvalStatus;
  final double driverRating;
  final int totalRides;
  final String? rejectedReason;
  final DateTime? approvedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,

      // Driver documents
      idCardUrl: json['id_card_url'] as String,
      criminalRecordUrl: json['criminal_record_url'] as String,
      drivingLicenseUrl: json['driving_license_url'] as String,

      // Car information
      carType: json['car_type'] as String,
      carModel: json['car_model'] as String,
      carColor: json['car_color'] as String,
      licensePlate: json['license_plate'] as String,
      carImages: (json['car_images'] as List<dynamic>?)
          ?.map((image) => image as String)
          .toList(),

      // Driver status and statistics
      approvalStatus: DriverApprovalStatusX.fromDb(
        json['approval_status'] as String,
      ),
      driverRating: (json['driver_rating'] as num).toDouble(),
      totalRides: json['total_rides'] as int,
      rejectedReason: json['rejected_reason'] as String?,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,

      // Timestamps
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
