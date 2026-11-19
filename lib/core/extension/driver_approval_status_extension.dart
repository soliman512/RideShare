enum DriverApprovalStatus { underReview, approved, rejected }

extension DriverApprovalStatusX on DriverApprovalStatus {
  String get dbValue {
    switch (this) {
      case DriverApprovalStatus.underReview:
        return 'under_review';

      case DriverApprovalStatus.approved:
        return 'approved';

      case DriverApprovalStatus.rejected:
        return 'rejected';
    }
  }

  static DriverApprovalStatus fromDb(String value) {
    switch (value) {
      case 'under_review':
        return DriverApprovalStatus.underReview;

      case 'approved':
        return DriverApprovalStatus.approved;

      case 'rejected':
        return DriverApprovalStatus.rejected;

      default:
        return DriverApprovalStatus.underReview;
    }
  }
}
