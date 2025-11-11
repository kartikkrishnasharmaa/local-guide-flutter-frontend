import 'package:localguider/common_libs.dart';
import 'package:localguider/main.dart';

import '../responsive.dart';

BoxDecoration strokeBoxDecoration(context, {color, radius, borderColor}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius ?? sizing(10, context)),
    border: Border.all(
      color: borderColor ?? $styles.colors.borderColor()
    )
  );
}

BoxDecoration roundBoxDecoration(context, {color, radius, borderColor}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius ?? sizing(10, context)),
    color: color ?? $styles.colors.greyLight
  );
}

EdgeInsets padding(double padding) {
  return EdgeInsets.all(padding);
}