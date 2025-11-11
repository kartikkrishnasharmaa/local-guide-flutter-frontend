import 'dart:ui';

import 'package:localguider/models/serializable.dart';
import 'package:localguider/ui/enums/withdrawal_status.dart';

import '../../main.dart';
import '../../ui/dashboard/appointment_status.dart';
import '../../utils/time_utils.dart';

class WithdrawalModel extends Serializable {
  WithdrawalModel({
      this.id, 
      this.userId, 
      this.photographerId, 
      this.guiderId, 
      this.amount, 
      this.charge, 
      this.amountToBeSettled, 
      this.paymentStatus, 
      this.bankName, 
      this.accountNumber, 
      this.accountHolderName, 
      this.ifsc, 
      this.upiId, 
      this.useUpi, 
      this.other, 
      this.createdOn, 
      this.lastUpdate,});

  WithdrawalModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    amount = json['amount'];
    charge = json['charge'];
    amountToBeSettled = json['amountToBeSettled'];
    paymentStatus = json['paymentStatus'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    accountHolderName = json['accountHolderName'];
    ifsc = json['ifsc'];
    upiId = json['upiId'];
    useUpi = json['useUpi'];
    other = json['other'];
    createdOn = json['createdOn'] != null ? TimeUtils.parseUtcToLocal(json['createdOn'] as String) : null;
    lastUpdate = json['lastUpdate'] != null ? TimeUtils.parseUtcToLocal(json['lastUpdate'] as String) : null;
  }
  num? id;
  num? userId;
  num? photographerId;
  num? guiderId;
  num? amount;
  num? charge;
  num? amountToBeSettled;
  String? paymentStatus;
  String? bankName;
  String? accountNumber;
  String? accountHolderName;
  String? ifsc;
  String? upiId;
  bool? useUpi;
  String? other;
  DateTime? createdOn;
  DateTime? lastUpdate;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['amount'] = amount;
    map['charge'] = charge;
    map['amountToBeSettled'] = amountToBeSettled;
    map['paymentStatus'] = paymentStatus;
    map['bankName'] = bankName;
    map['accountNumber'] = accountNumber;
    map['accountHolderName'] = accountHolderName;
    map['ifsc'] = ifsc;
    map['upiId'] = upiId;
    map['useUpi'] = useUpi;
    map['other'] = other;
    map['createdOn'] = createdOn?.toIso8601String();
    map['lastUpdate'] = lastUpdate?.toIso8601String();
    return map;
  }

}

Color $getWithdrawalStatusColor(status) {
  if(status == WithdrawalStatus.inProgress.value) {
    return $styles.colors.orange;
  } else if(status == WithdrawalStatus.success.value) {
    return $styles.colors.green;
  } else if(status == WithdrawalStatus.canceled.value) {
    return $styles.colors.red;
  }
  return $styles.colors.black;
}