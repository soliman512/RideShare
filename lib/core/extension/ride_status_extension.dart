enum RideStatus { active, inProgress, cancelled, completed }

extension RideStatusX on RideStatus {
  String get dbValue {
    switch (this) {
      case RideStatus.active:
        return 'active';

      case RideStatus.inProgress:
        return 'in_progress';

      case RideStatus.cancelled:
        return 'cancelled';
      case RideStatus.completed:
        return 'completed';
    }
  }

  static RideStatus fromDb(String value) {
    switch (value) {
      case 'in_progress':
        return RideStatus.inProgress;

      case 'cancelled':
        return RideStatus.cancelled;

      case 'completed':
        return RideStatus.completed;

      default:
        return RideStatus.active;
    }
  }
}
