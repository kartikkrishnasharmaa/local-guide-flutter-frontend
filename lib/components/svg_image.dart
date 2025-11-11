import 'package:flutter_svg/svg.dart';
import 'package:localguider/style/styles.dart';

import '../common_libs.dart';
import '../main.dart';
import '../values/assets.dart';

class SvgImage extends StatelessWidget {
  double size = 24;
  Color? color;
  bool? noColor;
  String path;

  SvgImage(
      {this.size = 24,
      this.color,
      this.noColor,
      required this.path,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size,
        width: size,
        child: SvgPicture.asset(
          path,
          colorFilter: noColor == true
              ? null
              : (color != null
                  ? color?.colorFilter
                  : $styles.colors.black.colorFilter),
        ));
  }
}
