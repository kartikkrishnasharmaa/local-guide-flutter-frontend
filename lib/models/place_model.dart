import 'package:localguider/models/serializable.dart';

class PlaceModel extends Serializable {
  PlaceModel({
      this.id, 
      this.placeName, 
      this.featuredImage, 
      this.state,
      this.city,
      this.mapUrl,
      this.fullAddress,
      this.latitude, 
      this.longitude, 
      this.rating,
      this.isTop,
      this.description, 
      this.timing, 
      this.openAllDay, 
      this.createdOn, 
      this.lastUpdate,});

  PlaceModel.fromJson(dynamic json) {
    id = json['id'];
    placeName = json['placeName'];
    featuredImage = json['featuredImage'];
    state = json['state'];
    city = json['city'];
    mapUrl = json['mapUrl'];
    fullAddress = json['fullAddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    rating = json['rating'];
    isTop = json['isTop'];
    description = json['description'];
    timing = json['timing'];
    openAllDay = json['openAllDay'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
  }
  num? id;
  String? placeName;
  String? featuredImage;
  String? state;
  String? city;
  String? mapUrl;
  String? fullAddress;
  num? latitude;
  num? longitude;
  num? rating;
  String? description;
  String? timing;
  bool? openAllDay;
  bool? isTop;
  String? createdOn;
  String? lastUpdate;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['placeName'] = placeName;
    map['featuredImage'] = featuredImage;
    map['state'] = state;
    map['city'] = city;
    map['mapUrl'] = mapUrl;
    map['isTop'] = isTop;
    map['fullAddress'] = fullAddress;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['rating'] = rating;
    map['description'] = description;
    map['timing'] = timing;
    map['openAllDay'] = openAllDay;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    return map;
  }

}