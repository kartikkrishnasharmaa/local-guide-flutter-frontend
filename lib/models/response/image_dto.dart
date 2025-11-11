import 'package:localguider/models/serializable.dart';

class ImageDto extends Serializable {
  ImageDto({
      this.id, 
      this.title, 
      this.description, 
      this.image, 
      this.photographerId, 
      this.guiderId, 
      this.placeId, 
      this.createdOn, 
      this.lastUpdate,});

  ImageDto.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    placeId = json['placeId'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
  }
  num? id;
  String? title;
  String? description;
  String? image;
  num? photographerId;
  num? guiderId;
  num? placeId;
  String? createdOn;
  String? lastUpdate;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['placeId'] = placeId;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    return map;
  }

}