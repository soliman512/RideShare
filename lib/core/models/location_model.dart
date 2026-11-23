
class LocationModel {
  final String address;
  final double latitude;
  final double longitude;

  const LocationModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['formatted'] ?? '',
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
    );
  }
}
