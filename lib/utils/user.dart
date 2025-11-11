import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/utils/share_pref.dart';

import '../main.dart';
import '../models/response/user_data.dart';

class User {

  saveDetails(UserData userData) {
    $sharedPrefs.setString($strings.USER, json.encode(userData.toJson()));
  }

  UserData? getUser() {
    String? user = $sharedPrefs.getString($strings.USER);
    if(user.isNullOrEmpty()) return null;
    return UserData.fromJson(json.decode(user!));
  }

  saveToken(String token) {
    $sharedPrefs.setString($strings.API_TOKEN, token);
  }

  String? getToken() {
    return $sharedPrefs.getString($strings.API_TOKEN);
  }

  isVerified() {
    return !$sharedPrefs.getString($strings.USER).isNullOrEmpty() && !$sharedPrefs.getString($strings.API_TOKEN).isNullOrEmpty();
  }

  logOut() async {
    await $sharedPrefs.clear();
    await FirebaseAuth.instance.signOut();
  }

}