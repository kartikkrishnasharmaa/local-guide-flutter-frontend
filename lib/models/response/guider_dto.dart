
import 'package:localguider/models/response/time_slot_dto.dart';
import 'package:localguider/models/serializable.dart';

class GuiderDto extends Serializable {
  GuiderDto({
    this.id,
    this.userId,
    this.firmName,
    this.description,
    this.phone,
    this.email,
    this.rating,
    this.currentPlanId,
    this.balance,
    this.latitude,
    this.longitude,
    this.ratePerHour,
    this.govtId,
    this.servicePlaces,
    this.placeName,
    this.featuredImage,
    this.govtIdType,
    this.approvalStatus,
    this.reasonOfDecline,
    this.approvedOn,
    this.createdOn,
    this.lastUpdate,
    this.appointmentOn,
    this.openAllDay,
    this.timing,
    this.timeSlots,});

  GuiderDto.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    firmName = json['firmName'];
    description = json['description'];
    phone = json['phone'];
    email = json['email'];
    rating = json['rating'];
    currentPlanId = json['currentPlanId'];
    balance = json['balance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ratePerHour = json['ratePerHour'];
    govtId = json['govtId'];
    servicePlaces = json['servicePlaces'];
    placeName = json['placeName'];
    featuredImage = json['featuredImage'];
    govtIdType = json['govtIdType'];
    approvalStatus = json['approvalStatus'];
    reasonOfDecline = json['reasonOfDecline'];
    approvedOn = json['approvedOn'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
    appointmentOn = json['appointmentOn'];
    openAllDay = json['openAllDay'];
    timing = json['timing'];
    if (json['timeSlots'] != null) {
      timeSlots = [];
      json['timeSlots'].forEach((v) {
        timeSlots?.add(TimeSlotDto.fromJson(v));
      });
    }
  }
  num? id;
  num? userId;
  String? firmName;
  String? description;
  String? phone;
  String? email;
  num? rating;
  String? currentPlanId;
  num? balance;
  num? latitude;
  num? longitude;
  num? ratePerHour;
  String? govtId;
  String? servicePlaces;
  String? placeName;
  String? featuredImage;
  String? govtIdType;
  String? approvalStatus;
  String? reasonOfDecline;
  String? approvedOn;
  String? createdOn;
  String? lastUpdate;
  String? appointmentOn;
  bool? openAllDay;
  String? timing;
  List<TimeSlotDto>? timeSlots;

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
    map['currentPlanId'] = currentPlanId;
    map['balance'] = balance;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['ratePerHour'] = ratePerHour;
    map['govtId'] = govtId;
    map['servicePlaces'] = servicePlaces;
    map['placeName'] = placeName;
    map['featuredImage'] = featuredImage;
    map['govtIdType'] = govtIdType;
    map['approvalStatus'] = approvalStatus;
    map['reasonOfDecline'] = reasonOfDecline;
    map['approvedOn'] = approvedOn;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    map['appointmentOn'] = appointmentOn;
    map['openAllDay'] = openAllDay;
    map['timing'] = timing;
    if (timeSlots != null) {
      map['timeSlots'] = timeSlots?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
