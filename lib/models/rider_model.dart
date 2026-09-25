
enum RideStatus{
  active,
  cancelled,
  full,
  completed
}

class DriverRideData {
  final String destination;
  final String departureDate;
  final String departureTime;
  final int bookedSeats;
  final int totalSeats;
  final double distance;
  final RideStatus status;

  const DriverRideData({
    required this.destination,
    required this.departureDate,
    required this.departureTime,
    required this.bookedSeats,
    required this.totalSeats,
    required this.distance,
    required this.status,
  });
}