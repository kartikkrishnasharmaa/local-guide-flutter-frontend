import 'package:localguider/models/serializable.dart';

class NotificationModel extends Serializable {
  NotificationModel({
      this.id, 
      this.title, 
      this.description, 
      this.type, 
      this.forAll, 
      this.fromAdmin, 
      this.forPhotographers, 
      this.forGuiders, 
      this.forUsers, 
      this.markAsRead, 
      this.userId, 
      this.note, 
      this.photographerId, 
      this.guiderId, 
      this.createdOn, 
      this.lastUpdate,});

  NotificationModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    forAll = json['forAll'];
    fromAdmin = json['fromAdmin'];
    forPhotographers = json['forPhotographers'];
    forGuiders = json['forGuiders'];
    forUsers = json['forUsers'];
    markAsRead = json['markAsRead'];
    userId = json['userId'];
    note = json['note'];
    photographerId = json['photographerId'];
    guiderId = json['guiderId'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
  }
  num? id;
  String? title;
  String? description;
  String? type;
  bool? forAll;
  bool? fromAdmin;
  bool? forPhotographers;
  bool? forGuiders;
  bool? forUsers;
  bool? markAsRead;
  num? userId;
  String? note;
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
    map['type'] = type;
    map['forAll'] = forAll;
    map['fromAdmin'] = fromAdmin;
    map['forPhotographers'] = forPhotographers;
    map['forGuiders'] = forGuiders;
    map['forUsers'] = forUsers;
    map['markAsRead'] = markAsRead;
    map['userId'] = userId;
    map['note'] = note;
    map['photographerId'] = photographerId;
    map['guiderId'] = guiderId;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    return map;
  }

}