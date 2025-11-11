import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/serializable.dart';

class UserData extends Serializable {
  UserData({
    this.id,
    this.name,
    this.countryCode,
    this.phone,
    this.email,
    this.password,
    this.photographer,
    this.rememberMe,
    this.guider,
    this.address,
    this.latitude,
    this.longitude,
    this.balance,
    this.gender,
    this.dob,
    this.username,
    this.profile,
    this.createdOn,
    this.lastUpdate,
    this.isBlocked,
    this.reasonOfBlock,
    this.photographerDetails,
    this.guiderDetails,
    this.pid,
    this.gid,
  });


  UserData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['countryCode'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    photographer = json['photographer'];
    rememberMe = json['rememberMe'];
    guider = json['guider'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    balance = json['balance'];
    username = json['username'];
    gender = json['gender'];
    dob = json['dob'];
    profile = json['profile'];
    createdOn = json['createdOn'];
    lastUpdate = json['lastUpdate'];
    reasonOfBlock = json['reasonOfBlock'];
    isBlocked = json['isBlocked'];
    photographerDetails = json['photographerDetails'] != null
        ? PhotographerDto.fromJson(json['photographerDetails'])
        : null;
    guiderDetails = json['guiderDetails'] != null
        ? PhotographerDto.fromJson(json['guiderDetails'])
        : null;
    pid = json['pid'];
    gid = json['gid'];
  }

  num? id;
  String? name;
  String? countryCode;
  String? phone;
  String? email;
  String? password;
  bool? photographer;
  bool? rememberMe;
  bool? guider;
  String? address;
  String? gender;
  String? dob;
  num? latitude;
  num? longitude;
  num? balance;
  String? username;
  String? profile;
  String? createdOn;
  String? lastUpdate;
  PhotographerDto? photographerDetails;
  dynamic guiderDetails;
  num? pid;
  num? gid;
  bool? isBlocked;
  String? reasonOfBlock;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['countryCode'] = countryCode;
    map['phone'] = phone;
    map['email'] = email;
    map['password'] = password;
    map['photographer'] = photographer;
    map['rememberMe'] = rememberMe;
    map['guider'] = guider;
    map['address'] = address;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['balance'] = balance;
    map['gender'] = gender;
    map['dob'] = dob;
    map['username'] = username;
    map['profile'] = profile;
    map['createdOn'] = createdOn;
    map['lastUpdate'] = lastUpdate;
    map['isBlocked'] = isBlocked;
    map['reasonOfBlock'] = reasonOfBlock;
    if (map['photographerDetails'] != null) {
      map['photographerDetails'] = photographerDetails?.toJson();
    }
    if (map['guiderDetails'] != null) {
      map['guiderDetails'] = guiderDetails?.toJson();
    }
    map['pid'] = pid;
    map['gid'] = gid;
    return map;
  }
}
