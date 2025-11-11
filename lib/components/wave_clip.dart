import 'package:localguider/main.dart';

import '../common_libs.dart';

class WaveClip extends StatelessWidget {
  const WaveClip({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 100,
        color: $styles.colors.blue,
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 4);
    var firstControlPoint =
        Offset(size.width / 9, size.height / 4 - 65); // Swap
    var firstEndPoint = Offset(size.width / 2, size.height / 3 - 40); // Swap
    var secondControlPoint =
        Offset(size.width - (size.width / 6), size.height / 3); // Swap
    var secondEndPoint = Offset(size.width, size.height / 3); // Swap

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
