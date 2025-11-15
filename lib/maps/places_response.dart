import 'package:localguider/models/serializable.dart';

class PlacesResponse extends Serializable {
  List<Predictions>? predictions;
  String? status;

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
  String? description;
  String? placeId;
  String? mapUrl;
  double? latitude;
  double? longitude;

  Predictions({
    this.description,
    this.placeId,
    this.mapUrl,
    this.latitude,
    this.longitude,
  });

  Predictions.fromJson(dynamic json) {
    description = json['description'];

    placeId = json['place_id'];         // FIXED (was num, now String)
    mapUrl = json['mapUrl'];

    latitude = json['latitude']?.toDouble();   // FIXED
    longitude = json['longitude']?.toDouble(); // FIXED
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['description'] = description;
    map['place_id'] = placeId;
    map['mapUrl'] = mapUrl;
    map['latitude'] = latitude;
    map['longitude'] = longitude;

    return map;
  }
}
