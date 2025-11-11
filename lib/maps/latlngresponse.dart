import 'package:localguider/models/serializable.dart';

class LatLngResponse extends Serializable {
  LatLngResponse({
      this.result, 
      this.status,});

  LatLngResponse.fromJson(dynamic json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    status = json['status'];
  }
  Result? result;
  String? status;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.toJson();
    }
    map['status'] = status;
    return map;
  }

}

class Result {
  Result({
      this.geometry, 
      this.icon, 
      this.iconMaskBaseUri, 
      this.name, 
      this.placeId, 
      this.reference, 
      this.url,});

  Result.fromJson(dynamic json) {
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    placeId = json['place_id'];
    reference = json['reference'];
    url = json['url'];
  }
  Geometry? geometry;
  String? icon;
  String? iconMaskBaseUri;
  String? name;
  String? placeId;
  String? reference;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    map['icon'] = icon;
    map['icon_mask_base_uri'] = iconMaskBaseUri;
    map['name'] = name;
    map['place_id'] = placeId;
    map['reference'] = reference;
    map['url'] = url;
    return map;
  }

}

class Geometry {
  Geometry({
      this.location,});

  Geometry.fromJson(dynamic json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }
  Location? location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) {
      map['location'] = location?.toJson();
    }
    return map;
  }

}

class Location {
  Location({
      this.lat, 
      this.lng,});

  Location.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }
  double? lat;
  double? lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

}