
import 'package:localguider/models/serializable.dart';

class TimeSlotDto extends Serializable {
  TimeSlotDto({
    this.id,
    this.startTime,
    this.endTime,
    this.title,
    this.createdOn,
    this.lastUpdate,
    this.photographer,
    this.appointment,});

  TimeSlotDto.fromJson(dynamic json) {
    id = json['id'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    title = json['title'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
    photographer = json['photographer'];
    appointment = json['appointment'];
  }
  num? id;
  String? startTime;
  String? endTime;
  String? title;
  String? createdOn;
  String? lastUpdate;
  dynamic photographer;
  dynamic appointment;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['title'] = title;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    map['photographer'] = photographer;
    map['appointment'] = appointment;
    return map;
  }

}