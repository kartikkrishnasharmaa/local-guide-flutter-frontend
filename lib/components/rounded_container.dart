import '../../common_libs.dart';
import '../../main.dart';
import '../responsive.dart';
import '../style/colors.dart';

class RoundedContainer extends StatelessWidget {

  double diameter;
  double? radius;
  double strokeWidth = 0;
  Widget child;
  Color? strokeColor;
  Color? color;

  RoundedContainer(
      {super.key,
      required this.diameter,
      this.radius,
      required this.child,
      this.color,
      this.strokeWidth = 0,
      this.strokeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizing(diameter, context),
      width: sizing(diameter, context),
      decoration: BoxDecoration(
          color: color ?? colorTransparent,
          borderRadius: BorderRadius.all(
              Radius.circular(radius ?? sizing(diameter / 2, context))),
          border: Border.all(
              width: sizing(strokeWidth, context),
              color: strokeColor ?? $styles.colors.caption)),
      child: child,
    );
  }
}
