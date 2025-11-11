import 'package:dio/dio.dart';

class UpdateUserRequestDto {
  UpdateUserRequestDto({
    this.userId,
    this.name,
    this.phone,
    this.username,
    this.countryCode,
    this.password,
    this.address,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.fcm,
    this.latitude,
    this.profile,
    this.longitude,
    this.isBlocked,
    this.reasonOfBlock,
  });

  UpdateUserRequestDto.fromJson(dynamic json) {
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    username = json['username'];
    countryCode = json['countryCode'];
    password = json['password'];
    address = json['address'];
    dateOfBirth = json['dob'];
    email = json['email'];
    gender = json['gender'];
    fcm = json['fcm'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    profile = json['longitude'];
    isBlocked = json['isBlocked'];
    reasonOfBlock = json['reasonOfBlock'];
  }

  String? userId;
  String? name;
  String? phone;
  String? username;
  String? email;
  String? countryCode;
  String? password;
  String? dateOfBirth;
  String? gender;
  String? address;
  String? fcm;
  MultipartFile? profile;
  num? latitude;
  num? longitude;
  bool? isBlocked;
  String? reasonOfBlock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['phone'] = phone;
    map['username'] = username;
    map['countryCode'] = countryCode;
    map['password'] = password;
    map['email'] = email;
    map['gender'] = gender;
    map['address'] = address;
    map['fcm'] = fcm;
    map['dob'] = dateOfBirth;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['isBlocked'] = isBlocked;
    map['reasonOfBlock'] = reasonOfBlock;
    map['profile'] = profile;
    return map;
  }

}