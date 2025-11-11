import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/models/serializable.dart';

class SignInResponse extends Serializable {
  SignInResponse({
      this.token, 
      this.refreshToken, 
      this.user,});

  SignInResponse.fromJson(dynamic json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }
  String? token;
  String? refreshToken;
  UserData? user;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['refreshToken'] = refreshToken;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}