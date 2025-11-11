import '../common_libs.dart';

export 'dart:math';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:gap/gap.dart';

int userLevel = 1;

Color colorTransparent = Colors.transparent;

class AppColors {
  final Color background = const Color(0xFFF8F8F8);

  final Color title = Colors.black;

  final Color caption = const Color(0xFF7D7873);
  final Color body = const Color(0xFF514F4D);
  final Color greyStrong = const Color(0xFF272625);
  final Color greyStrong2 = const Color(0xFF252524);
  final Color greyMedium = const Color(0xFF9D9995);
  final Color greyLight = const Color(0xFFD8D6D5);
  final Color greyLight2 = const Color(0xFF8B8B8B);
  final Color greyBg = const Color(0xFFF8F8F8);
  final Color red = const Color(0xFFFF0000);
  final Color green = const Color(0xFF25A244);
  final Color white = Colors.white;
  final Color black = const Color(0xFF1E1B18);
  final Color realBlack = const Color(0xFF000000);
  final Color yellow = const Color(0xFFfbd806);
  final Color orange = const Color(0xFFff9e00);
  final Color violet = const Color(0xFF8F00FF);
  final Color blue = const Color(0xFF355b99);
  final Color blue2 = const Color(0xff4167a5);
  final Color blue3 = const Color(0xff496eab);
  final Color blueBg = const Color(0xFFF7FCFF);
  final Color blueSurface = const Color(0xFF94BDFF);
  final Color secondarySurface = const Color(0xFFF1FAFF);

  final Color whiteGreyText = Color(0xFF7D7873);

  Color borderColor() {
    return greyLight2;
  }

  final Color accent1 = const Color(0xFF4D4D4D);
  final Color accent2 = const Color(0xFFBEABA1);
  final Color accent3Gold = const Color(0xFFfbd6a1);

  ThemeData toThemeData() {
    TextTheme txtTheme = ThemeData
        .light()
        .textTheme;

    Color txtColor = white;
    ColorScheme colorScheme = ColorScheme(
        brightness: Brightness.light,
        primary: background,
        primaryContainer: background,
        secondary: background,
        secondaryContainer: background,
        background: background,
        surface: background,
        onBackground: txtColor,
        onSurface: txtColor,
        onError: Colors.red.shade400,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.red.shade400);

    var t = ThemeData.from(
        textTheme: txtTheme, colorScheme: colorScheme, useMaterial3: true)
        .copyWith(
      textSelectionTheme: TextSelectionThemeData(cursorColor: title),
      highlightColor: title,
    );

    return t;
  }
}
