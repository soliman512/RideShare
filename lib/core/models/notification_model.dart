enum NotificationType {
  bookingConfirmed,
  rideCancelled,
  rideCompleted,
  reviewReceived,
  driverCancelled,
}

class NotificationModel {
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });
}