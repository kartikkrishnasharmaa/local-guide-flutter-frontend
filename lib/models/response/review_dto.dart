import '../serializable.dart';

class ReviewDto extends Serializable {
  ReviewDto({
      this.id, 
      this.userId, 
      this.photographerId, 
      this.guiderId, 
      this.placeId, 
      this.rating,
      this.newRating,
      this.message,
      this.createdOn, 
      this.lastUpdate,});

  ReviewDto.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    placeId = json['placeId'];
    rating = json['rating'];
    newRating = json['newRating'];
    fullName = json['fullName'];
    profileImage = json['profileImage'];
    message = json['message'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
  }
  num? id;
  num? userId;
  num? photographerId;
  num? guiderId;
  num? placeId;
  num? rating;
  num? newRating;
  String? fullName;
  String? profileImage;
  String? message;
  String? createdOn;
  String? lastUpdate;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['placeId'] = placeId;
    map['rating'] = rating;
    map['newRating'] = newRating;
    map['fullName'] = fullName;
    map['profileImage'] = profileImage;
    map['message'] = message;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    return map;
  }

}