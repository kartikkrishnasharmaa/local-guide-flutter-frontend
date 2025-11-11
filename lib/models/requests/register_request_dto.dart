class RegisterRequestDto {
  RegisterRequestDto({
      this.name, 
      this.phone, 
      this.username, 
      this.countryCode, 
      this.password, 
      this.address,
      this.dateOfBirth,
      this.gender,
      this.latitude, 
      this.longitude,});

  RegisterRequestDto.fromJson(dynamic json) {
    name = json['name'];
    phone = json['phone'];
    username = json['username'];
    countryCode = json['countryCode'];
    dateOfBirth = json['dob'];
    password = json['password'];
    address = json['address'];
    gender = json['gender'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  String? name;
  String? phone;
  String? username;
  String? countryCode;
  String? password;
  String? dateOfBirth;
  String? gender;
  String? address;
  num? latitude;
  num? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['phone'] = phone;
    map['username'] = username;
    map['countryCode'] = countryCode;
    map['password'] = password;
    map['gender'] = gender;
    map['address'] = address;
    map['dob'] = dateOfBirth;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }

}