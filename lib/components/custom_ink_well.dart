import '../main.dart';
import '../responsive.dart';
import '../style/colors.dart';

class CustomInkWell extends StatelessWidget {
  Widget child;
  Function? onTap;
  Function(bool hovering)? onHover;
  double radius = 10;
  Color? rippleColor = $styles.colors.greyLight;
  Color? bgColor = $styles.colors.greyLight;

  CustomInkWell(
      {required this.child,
      this.onTap,
        this.onHover,
      this.radius = 10,
      this.rippleColor,
      this.bgColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? colorTransparent,
      borderRadius: BorderRadius.circular(sizing(radius,context)),
      child: InkWell(
        borderRadius: BorderRadius.circular(sizing(radius/2,context)),
        splashColor: rippleColor ?? colorTransparent,
        highlightColor: colorTransparent,
        onTap: () {
          if (onTap != null) onTap!();
        },
        onHover: (hovering) {
          if (onHover != null) onHover!(hovering);
        },
        child: child,
      ),
    );
  }
}
