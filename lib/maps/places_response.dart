import 'package:localguider/models/serializable.dart';

class PlacesResponse extends Serializable {
  PlacesResponse({this.predictions, this.status});

  PlacesResponse.fromJson(dynamic json) {
    if (json['predictions'] != null) {
      predictions = [];
      json['predictions'].forEach((v) {
        predictions?.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  List<Predictions>? predictions;
  String? status;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (predictions != null) {
      map['predictions'] = predictions?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }
}

class Predictions extends Serializable {
  Predictions({
    this.description,
    this.placeId,
    this.reference,
    this.mapUrl,
    this.latitude,
    this.longitude,
  });

  Predictions.fromJson(dynamic json) {
    description = json['description'];
    placeId = json['place_id'];
    reference = json['reference'];
    mapUrl = json['mapUrl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  String? description;
  num? placeId;
  String? reference;
  String? mapUrl;
  num? latitude;
  num? longitude;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['place_id'] = placeId;
    map['reference'] = reference;
    map['mapUrl'] = mapUrl;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
