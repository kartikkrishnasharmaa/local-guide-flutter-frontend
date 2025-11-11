import 'dart:ui';

import 'package:localguider/models/serializable.dart';

import '../../main.dart';

class PhotographerDto extends Serializable {
  PhotographerDto({
    this.id,
    this.userId,
    this.firmName,
    this.description,
    this.phone,
    this.email,
    this.rating,
    this.placeName,
    this.currentPlanId,
    this.balance,
    this.latitude,
    this.longitude,
    this.ratePerHour,
    this.idProofFront,
    this.idProofBack,
    this.photograph,
    this.placeId,
    this.places,
    this.featuredImage,
    this.idProofType,
    this.address,
    this.approvalStatus,
    this.reasonOfDecline,
    this.approvedOn,
    this.createdOn,
    this.lastUpdate,
    this.active,
    this.openAllDay,
    this.timing,
  });

  PhotographerDto.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    firmName = json['firmName'];
    description = json['description'];
    phone = json['phone'];
    email = json['email'];
    rating = json['rating'];
    placeName = json['placeName'];
    currentPlanId = json['currentPlanId'];
    balance = json['balance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ratePerHour = json['ratePerHour'];
    idProofFront = json['idProofFront'];
    idProofBack = json['idProofBack'];
    photograph = json['photograph'];
    placeId = json['placeId'];
    places = json['places'];
    featuredImage = json['featuredImage'];
    idProofType = json['idProofType'];
    address = json['address'];
    approvalStatus = json['approvalStatus'];
    reasonOfDecline = json['reasonOfDecline'];
    approvedOn = json['approvedOn'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
    active = json['active'];
    openAllDay = json['openAllDay'];
    timing = json['timing'];
  }

  num? id;
  num? userId;
  String? firmName;
  String? description;
  String? phone;
  String? email;
  num? rating;
  String? placeName;
  num? currentPlanId;
  num? balance;
  num? latitude;
  num? longitude;
  String? ratePerHour;
  String? idProofFront;
  String? idProofBack;
  String? photograph;
  num? placeId;
  String? places;
  String? featuredImage;
  String? idProofType;
  String? address;
  String? approvalStatus;
  String? reasonOfDecline;
  String? approvedOn;
  String? createdOn;
  String? lastUpdate;
  bool? active;
  bool? openAllDay;
  String? timing;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['firmName'] = firmName;
    map['description'] = description;
    map['phone'] = phone;
    map['email'] = email;
    map['rating'] = rating;
    map['placeName'] = placeName;
    map['currentPlanId'] = currentPlanId;
    map['balance'] = balance;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['ratePerHour'] = ratePerHour;
    map['idProofFront'] = idProofFront;
    map['idProofBack'] = idProofBack;
    map['photograph'] = photograph;
    map['placeId'] = placeId;
    map['places'] = places;
    map['featuredImage'] = featuredImage;
    map['idProofType'] = idProofType;
    map['address'] = address;
    map['approvalStatus'] = approvalStatus;
    map['reasonOfDecline'] = reasonOfDecline;
    map['approvedOn'] = approvedOn;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    map['active'] = active;
    map['openAllDay'] = openAllDay;
    map['timing'] = timing;
    return map;
  }
}

Color $getApprovalStatusColor(status) {
  if(status == "In Review") {
    return $styles.colors.orange;
  } else if(status == "Approved") {
    return $styles.colors.green;
  } else if(status == "Declined") {
    return $styles.colors.red;
  }
  return $styles.colors.black;
}