
import 'package:ride_share/core/extension/ride_status_extension.dart';

class RideModel {
  final String id;
  final String driverId;

  final DateTime departureDate;
  final String departureTime;

  final int totalSeats;
  final int availableSeats;

  final double totalDistance;
  final double totalFare;
  final double pricePerKm;

  final String? notes;
  final RideStatus status;

  const RideModel({
    required this.id,
    required this.driverId,
    required this.departureDate,
    required this.departureTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.totalDistance,
    required this.totalFare,
    required this.pricePerKm,
    required this.status,
    this.notes,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      departureDate: DateTime.parse(
        json['departure_date'] as String,
      ),
      departureTime: json['departure_time'] as String,
      totalSeats: (json['total_seats'] as num).toInt(),
      availableSeats: (json['available_seats'] as num).toInt(),
      totalDistance: (json['total_distance'] as num).toDouble(),
      totalFare: (json['total_fare'] as num).toDouble(),
      pricePerKm: (json['price_per_km'] as num).toDouble(),
      notes: json['notes'] as String?,
      status: RideStatusX.fromDb(json['status'] as String),
    );
  }
}
