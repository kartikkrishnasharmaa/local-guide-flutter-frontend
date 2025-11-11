import '../serializable.dart';

class LoginRequestDto extends Serializable {

  String? phone;
  String? password;

  LoginRequestDto(this.phone, this.password);

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = phone;
    map['password'] = password;
    return map;
  }

}