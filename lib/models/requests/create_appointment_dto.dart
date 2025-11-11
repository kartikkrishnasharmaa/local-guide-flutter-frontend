class CreateAppointmentDto {
  CreateAppointmentDto({
      this.userId, 
      this.photographerId, 
      this.guiderId, 
      this.dateTime, 
      this.transactionId, 
      this.serviceId, 
      this.appointmentCharge, 
      this.serviceCost, 
      this.totalPayment,
      this.note,
      this.paymentStatus,});

  CreateAppointmentDto.fromJson(dynamic json) {
    userId = json['userId'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    dateTime = json['dateTime'];
    transactionId = json['transactionId'];
    serviceId = json['serviceId'];
    appointmentCharge = json['appointmentCharge'];
    serviceCost = json['serviceCost'];
    totalPayment = json['totalPayment'];
    note = json['note'];
    paymentStatus = json['paymentStatus'];
  }
  num? userId;
  num? photographerId;
  num? guiderId;
  String? dateTime;
  String? transactionId;
  num? serviceId;
  num? appointmentCharge;
  num? serviceCost;
  num? totalPayment;
  String? note;
  String? paymentStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['dateTime'] = dateTime;
    map['transactionId'] = transactionId;
    map['serviceId'] = serviceId;
    map['appointmentCharge'] = appointmentCharge;
    map['serviceCost'] = serviceCost;
    map['totalPayment'] = totalPayment;
    map['note'] = note;
    map['paymentStatus'] = paymentStatus;
    return map;
  }

}