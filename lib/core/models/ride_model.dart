import 'package:ride_share/core/models/driver_model.dart';
import 'package:ride_share/core/models/user_model.dart';
import 'package:ride_share/core/models/vehicle_model.dart';

enum RideStatus { active, cancelled, full, completed }

class RideModel {
  final String id;
  final String from;
  final String destination;
  final DateTime departureDate;

  final List<String> stopPoints;

  final int totalSeats;
  final double distance;

  // Driver
  final DriverModel driver;
  //riders
  final List<UserModel> riders;

  // Car
  final VehicleModel car;
  // Ride
  final double price;
  final RideStatus status;

  const RideModel({
    required this.id,
    required this.from,
    required this.destination,
    required this.departureDate,
    required this.stopPoints,
    required this.totalSeats,
    required this.distance,
    required this.driver,
    required this.riders,
    required this.car,
    required this.price,
    required this.status,
  });
}
