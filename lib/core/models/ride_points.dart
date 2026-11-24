
class RidePointModel {
  final String id;
  final String rideId;

  final String address;
  final double latitude;
  final double longitude;

  final int stopOrder;

  final double distanceToDestination;
  final double fareToDestination;

  const RidePointModel({
    required this.id,
    required this.rideId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.stopOrder,
    required this.distanceToDestination,
    required this.fareToDestination,
  });

  factory RidePointModel.fromJson(Map<String, dynamic> json) {
    return RidePointModel(
      id: json['id'] as String,
      rideId: json['ride_id'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      stopOrder: (json['stop_order'] as num).toInt(),
      distanceToDestination:
          (json['distance_to_destination'] as num).toDouble(),
      fareToDestination:
          (json['fare_to_destination'] as num).toDouble(),
    );
  }
}
