import 'package:flutter/material.dart';

import 'colors.dart';

@immutable
class AppStyle {
  AppStyle({Size? screenSize}) {
    if (screenSize == null) {
      scale = 1;
      return;
    }
    final shortestSide = screenSize.shortestSide;
    const tabletXl = 1000;
    const tabletLg = 800;
    const tabletSm = 600;
    const phoneLg = 400;
    if (shortestSide > tabletXl) {
      scale = 1.25;
    } else if (shortestSide > tabletLg) {
      scale = 1.15;
    } else if (shortestSide > tabletSm) {
      scale = 1;
    } else if (shortestSide > phoneLg) {
      scale = .9; // phone
    } else {
      scale = .85; // small phone
    }
    //debugPrint('screenSize=$screenSize, scale=$scale');
  }

  late final double scale;

  /// Rounded edge corner radii
  late final _Corners corners = _Corners();

  /// Padding and margin values
  late final _Insets insets = _Insets(scale);

  /// Padding and margin values
  final AppColors colors = AppColors();

  /// Text Styling
  late final _Text text = _Text();

  /// Animation Durations
  final _Times times = _Times();

  /// Shared sizes
  late final _Sizes sizes = _Sizes();
}

@immutable
class _Times {
  final Duration fast = Duration(milliseconds: 300);
  final Duration med = Duration(milliseconds: 600);
  final Duration slow = Duration(milliseconds: 900);
  final Duration pageTransition = Duration(milliseconds: 200);
}

@immutable
class _Corners {
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

// TODO: add, @immutable when design is solidified
class _Sizes {
  double get maxContentWidth1 => 800;

  double get maxContentWidth2 => 600;

  double get maxContentWidth3 => 500;
  final Size minAppSize = Size(380, 250);
}

@immutable
class _Insets {
  _Insets(this._scale);

  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;
}

extension ColorFilterOnColor on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}

@immutable
class _Text {
  TextStyle getFontStyle(
      {FontStyles? fontStyles,
      bool isDark = false,
      bool isBold = false,
        bool isItalic = false,
      bool isUnderline = false,
      Color? color,
      double fontSize = 14}) {
    var mColor = color ?? (isDark ? Colors.black : Colors.white);

    var textStyle = TextStyle(
        fontFamily: fontStyles?.value ?? FontStyles.regular.value,
        fontSize: fontSize,
        fontStyle: isItalic ? FontStyle.italic : null,
        fontWeight: fontStyles == FontStyles.bold
            ? FontWeight.bold
            : (isBold ? FontWeight.bold : FontWeight.normal),
        color: mColor);

    return textStyle;
  }
}

Color getColorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

enum FontStyles { light, regular, medium, bold, openSansLight, openSansRegular, openSansMedium, openSansBold, }

extension FontNames on FontStyles {
  String get value {
    switch (this) {
      case FontStyles.light:
        return 'FuturaLight';
      case FontStyles.regular:
        return 'FuturaRegular';
      case FontStyles.medium:
        return 'FuturaMedium';
      case FontStyles.bold:
        return 'FuturaBold';
      case FontStyles.openSansLight:
        return 'OpenSansLight';
      case FontStyles.openSansRegular:
        return 'OpenSansRegular';
      case FontStyles.openSansMedium:
        return 'OpenSansMedium';
      case FontStyles.openSansBold:
        return 'OpenSansBold';
      default:
        return 'FuturaRegular';
    }
  }
}
