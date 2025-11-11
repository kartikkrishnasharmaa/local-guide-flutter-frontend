import 'dart:ui';

import 'package:localguider/ui/dashboard/appointment_status.dart';

import '../../main.dart';
import '../../utils/time_utils.dart';
import '../serializable.dart';

class AppointmentResponse extends Serializable {
  AppointmentResponse({
      this.id, 
      this.userId, 
      this.photographerId, 
      this.guiderId, 
      this.date, 
      this.serviceName, 
      this.serviceImage, 
      this.appointmentCharge, 
      this.serviceCost, 
      this.paymentStatus, 
      this.transactionId, 
      this.cancellationReason, 
      this.note, 
      this.appointmentStatus, 
      this.totalPayment, 
      this.createdOn, 
      this.lastUpdate, 
      this.customerName,});

  AppointmentResponse.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    date = json['date'];
    serviceName = json['serviceName'];
    serviceImage = json['serviceImage'];
    appointmentCharge = json['appointmentCharge'];
    serviceCost = json['serviceCost'];
    paymentStatus = json['paymentStatus'];
    transactionId = json['transactionId'];
    cancellationReason = json['cancellationReason'];
    note = json['note'];
    appointmentStatus = json['appointmentStatus'];
    totalPayment = json['totalPayment'];
    createdOn = json['createdOn'] != null ? TimeUtils.parseUtcToLocal(json['createdOn'] as String) : null;
    lastUpdate = json['lastUpdate'] != null ? TimeUtils.parseUtcToLocal(json['lastUpdate'] as String) : null;
    customerName = json['customerName'];
  }
  num? id;
  num? userId;
  num? photographerId;
  num? guiderId;
  String? date;
  String? serviceName;
  String? serviceImage;
  num? appointmentCharge;
  num? serviceCost;
  String? paymentStatus;
  String? transactionId;
  String? cancellationReason;
  String? note;
  String? appointmentStatus;
  num? totalPayment;
  DateTime? createdOn;
  DateTime? lastUpdate;
  String? customerName;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['date'] = date;
    map['serviceName'] = serviceName;
    map['serviceImage'] = serviceImage;
    map['appointmentCharge'] = appointmentCharge;
    map['serviceCost'] = serviceCost;
    map['paymentStatus'] = paymentStatus;
    map['transactionId'] = transactionId;
    map['cancellationReason'] = cancellationReason;
    map['note'] = note;
    map['appointmentStatus'] = appointmentStatus;
    map['totalPayment'] = totalPayment;
    map['createdOn'] = createdOn?.toIso8601String();
    map['lastUpdate'] = lastUpdate?.toIso8601String();
    map['customerName'] = customerName;
    return map;
  }

}

Color $getAppointmentStatusColor(status) {
  if(status == AppointmentStatus.requested) {
    return $styles.colors.orange;
  } else if(status == AppointmentStatus.accepted) {
    return $styles.colors.violet;
  } else if(status == AppointmentStatus.cancelled) {
    return $styles.colors.red;
  } else if(status == AppointmentStatus.onGoing) {
    return $styles.colors.blue;
  } else if(status == AppointmentStatus.completed) {
    return $styles.colors.green;
  }
  return $styles.colors.black;
}

String $getStatusText(status) {
  if(status == AppointmentStatus.requested) {
    return "Pending Request";
  } else if(status == AppointmentStatus.accepted) {
    return "Accepted";
  } else if(status == AppointmentStatus.cancelled) {
    return "Declined";
  } else if(status == AppointmentStatus.onGoing) {
    return "On Going";
  } else if(status == AppointmentStatus.completed) {
    return "Completed";
  }
  return "Pending Request";
}

