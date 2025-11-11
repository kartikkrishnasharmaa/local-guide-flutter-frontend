import 'package:localguider/common_libs.dart';

import '../main.dart';

Widget divider({double thickness = 1, Color? color, double horizontalPadding = 0.0}) {

  return Padding(
    padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
    child: Divider(
      thickness: thickness,
      height: thickness,
      color: color ?? $styles.colors.borderColor(),
    ),
  );

}