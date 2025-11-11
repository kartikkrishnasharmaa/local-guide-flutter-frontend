import 'package:flutter/cupertino.dart';

class SelectionModel {

  String? title;
  String? caption;
  IconData? icon;
  String? netImage;
  bool selected = false;

  SelectionModel({this.title, this.icon, this.selected = false, this.netImage, this.caption});

}
