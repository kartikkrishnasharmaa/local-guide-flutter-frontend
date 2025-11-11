import 'dart:convert';

import 'package:localguider/main.dart';
import 'package:localguider/models/wishlist.dart';
import 'package:localguider/utils/share_pref.dart';

class ObjectBox {


  List<Wishlist> getWishlist() {
    final jsonList = $sharedPrefs.getStringList($strings.WISHLIST) ?? [];
    return jsonList.map((e) => Wishlist.fromJson(json.decode(e))).toList();
  }

  void deleteById(int? id) {
    final jsonList = getWishlist();
    jsonList.removeWhere((element) => element.id == id);
    _updateList(jsonList);
  }

  void deleteByObjectId(String id) {
    final jsonList = getWishlist();
    jsonList.removeWhere((element) => element.objectId == id);
    _updateList(jsonList);
  }

  void addWishlist(Wishlist wishlist) {
    final jsonList = getWishlist();
    jsonList.add(wishlist);
    _updateList(jsonList);
  }

  void _updateList(List<Wishlist> jsonList) {
    $sharedPrefs.setStringList($strings.WISHLIST, jsonList.map((e) => json.encode(e)).toList());
  }

  bool existByObjectId(String id) {
    final jsonList = getWishlist();
    return jsonList.any((element) => element.objectId == id);
  }

}