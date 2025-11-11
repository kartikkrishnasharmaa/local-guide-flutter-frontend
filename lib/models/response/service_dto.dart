import '../serializable.dart';

class ServiceDto extends Serializable {
  ServiceDto({
      this.id, 
      this.title, 
      this.description, 
      this.image, 
      this.servicePrice, 
      this.photographerId, 
      this.guiderId, 
      this.createdOn, 
      this.lastUpdate,});

  ServiceDto.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    servicePrice = json['servicePrice'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
  }
  num? id;
  String? title;
  String? description;
  String? image;
  num? servicePrice;
  num? photographerId;
  num? guiderId;
  String? createdOn;
  String? lastUpdate;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['servicePrice'] = servicePrice;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    return map;
  }

}