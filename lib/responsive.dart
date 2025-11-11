import 'package:flutter/material.dart';

bool isMobView(BuildContext context) => MediaQuery.of(context).size.width < 850;

bool isSmallMobView(BuildContext context) => MediaQuery.of(context).size.height < 750;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width < 1100 &&
    MediaQuery.of(context).size.width >= 850;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1100;

class Responsive {
  static double size(BuildContext context, double size) {
    var mSize = size;
    if (isMobView(context)) {
      if(isSmallMobView(context)){
        mSize = size * 0.8;
      } else {
        mSize = size * 1;
      }
    } else if (isTablet(context)) {
      mSize = size * 1.4;
    } else if (isDesktop(context)) {
      mSize = size * 1.5;
    }
    return mSize;
  }
}

double sizing(double size, BuildContext context) {
  return Responsive.size(context, size);
}

double titleH1() {
  return 30;
}

double titleH2() {
  return 25;
}

double titleSize() {
  return 20;
}

double subTitleSize() {
  return 16;
}

double defaultFontSize() {
  return 14;
}

Widget gap(BuildContext context, {double? width, double? height}) {
  return SizedBox(
    height: Responsive.size(context, height ?? 0),
    width: Responsive.size(context, width ?? 0),
  );
}
