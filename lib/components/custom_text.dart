import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../main.dart';
import '../style/styles.dart';

const defaultTextSize = 14.0;

class CustomText extends StatelessWidget {
  String text;
  double fontSize = defaultTextSize;
  bool isBold = false;
  bool isItalic = false;
  FontStyles? style;
  TextAlign? align;
  Color? color;
  int maxLines;
  TextOverflow? overflow;
  bool isUnderline = false;

  CustomText(this.text,
      {super.key,
      this.style,
      this.align,
      this.isBold = false,
        this.isItalic = false,
      this.maxLines = 10,
      this.isUnderline = false,
        this.overflow,
      this.fontSize = defaultTextSize,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
        textAlign: align ?? TextAlign.start,
        style: $styles.text
            .getFontStyle(
                fontStyles: style,
                isBold: isBold,
                isItalic: isItalic,
                isUnderline: isUnderline,
                color: color ?? $styles.colors.title,
                fontSize: Responsive.size(context, fontSize))
            .copyWith(
              decoration:
                  isUnderline ? TextDecoration.underline : TextDecoration.none,
              decorationThickness: 1,
              decorationColor: isUnderline ? $styles.colors.blue : null,
            ));
  }
}
