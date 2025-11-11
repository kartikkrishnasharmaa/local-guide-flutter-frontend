import 'dart:ui';
import 'package:localguider/models/serializable.dart';
import 'package:localguider/utils/time_utils.dart';
import '../../main.dart';
import '../../ui/enums/withdrawal_status.dart';

class TransactionDto extends Serializable {
  late int id;
  int? userId;
  int? photographerId;
  int? guiderId;
  double? amount;
  bool? isCredit;
  String? paymentStatus;
  String? transactionId;
  String? paymentToken;
  String? paymentFor;
  String? other;
  String? gateway;
  DateTime? createdOn;
  DateTime? lastUpdate;

  TransactionDto({
    required this.id,
    this.userId,
    this.photographerId,
    this.guiderId,
    this.amount,
    this.isCredit,
    this.paymentStatus,
    this.transactionId,
    this.paymentFor,
    this.paymentToken,
    this.other,
    this.gateway,
    this.createdOn,
    this.lastUpdate,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      photographerId: json['photographerId'] as int?,
      guiderId: json['guiderId'] as int?,
      amount: json['amount'] as double?,
      isCredit: json['isCredit'] as bool?,
      paymentStatus: json['paymentStatus'] as String?,
      transactionId: json['transactionId'] as String?,
      paymentFor: json['paymentFor'].toString(),
      paymentToken: json['paymentToken'] as String?,
      other: json['other'] as String?,
      gateway: json['gateway'] as String?,
      createdOn: json['createdOn'] != null ? TimeUtils.parseUtcToLocal(json['createdOn'] as String) : null,
      lastUpdate: json['lastUpdate'] != null ? TimeUtils.parseUtcToLocal(json['lastUpdate'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'photographerId': photographerId,
      'guiderId': guiderId,
      'amount': amount,
      'isCredit': isCredit,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'paymentFor': paymentFor,
      'paymentToken': paymentToken,
      'other': other,
      'gateway': gateway,
      'createdOn': createdOn?.toIso8601String(),
      'lastUpdate': lastUpdate?.toIso8601String(),
    };
  }
}


Color $getPaymentStatusColor(status) {
  if(status == WithdrawalStatus.inProgress.value) {
    return $styles.colors.orange;
  } else if(status == WithdrawalStatus.success.value) {
    return $styles.colors.green;
  } else if(status == WithdrawalStatus.canceled.value) {
    return $styles.colors.red;
  }
  return $styles.colors.black;
}