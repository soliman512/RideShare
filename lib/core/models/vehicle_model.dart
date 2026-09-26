class VehicleModel {
  final String id;
  final String driverId; 
  final String plateNumber;
  final String make; 
  final String model;
  final String color;
  final int? year;
  final String? carImageUrl;
  final bool isActive; 
 
  const VehicleModel({
    required this.id,
    required this.driverId,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.color,
    this.year,
    this.carImageUrl,
    required this.isActive,
  });
}