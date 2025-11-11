class WithdrawalStatus {
  static const WithdrawalStatus inProgress = WithdrawalStatus._("In Progress");
  static const WithdrawalStatus canceled = WithdrawalStatus._("Canceled");
  static const WithdrawalStatus success = WithdrawalStatus._("Success");

  final String value;

  const WithdrawalStatus._(this.value);
}