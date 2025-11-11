import 'package:flutter/material.dart';

import '../../style/styles.dart';
import '../responsive.dart';
import '../values/assets.dart';
import 'app_image.dart';
import 'custom_text.dart';

class AppLogo extends StatelessWidget {
  bool isImage = true;
  bool isDark = false;
  LogoSize logoSize = LogoSize.small;
  double? fontSize;

  AppLogo(
      {super.key,
      this.isImage = true,
      this.logoSize = LogoSize.small,
      this.fontSize,
      this.isDark = false});

  @override
  Widget build(context) {
    return isImage
        ? SizedBox(
            height: sizing(
                logoSize == LogoSize.small
                    ? 50
                    : (logoSize == LogoSize.medium ? 80 : 140),
                context),
            child: AppImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  Logos.appLogo,
                )))
        : CustomText(
            "Local Guider",
            style: FontStyles.bold,
            fontSize: sizing( fontSize ?? _fontSize(), context),
          );
  }

  double _fontSize() {
    return logoSize == LogoSize.small
        ? 20
        : (logoSize == LogoSize.medium ? 50 : 70);
  }
}

enum LogoSize { small, medium, large }
