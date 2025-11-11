class ApprovalStatus {
  static const ApprovalStatus inReview = ApprovalStatus._("In Review");
  static const ApprovalStatus declined = ApprovalStatus._("Declined");
  static const ApprovalStatus approved = ApprovalStatus._("Approved");

  final String value;

  const ApprovalStatus._(this.value);
}