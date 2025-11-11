import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:localguider/components/rounded_container.dart';

import '../../common_libs.dart';
import '../../main.dart';
import '../responsive.dart';

class ProfileView extends StatelessWidget {
  String profileUrl;
  Uint8List? uintList;
  bool enableProfileHero;
  File? fileImage;
  double diameter;
  double strokeGap = 3;
  double outerStrokeWidth = 0;
  Color? outerStrokeColor;
  double innerStrokeWidth = 0;
  Color? innerStrokeColor;

  ProfileView(
      {super.key,
      required this.diameter,
      required this.profileUrl,
      this.enableProfileHero = false,
      this.strokeGap = 3,
      this.outerStrokeWidth = 0,
      this.outerStrokeColor,
      this.innerStrokeWidth = 0,
      this.innerStrokeColor,
      this.fileImage,
      this.uintList});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      diameter: diameter,
      strokeWidth: outerStrokeWidth,
      strokeColor: outerStrokeColor,
      child: Container(
        margin: EdgeInsets.all(sizing(strokeGap, context)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(sizing(diameter / 2, context))),
            border: Border.all(
                width: sizing(innerStrokeWidth, context),
                color: innerStrokeColor ?? $styles.colors.black)),
        child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(sizing(diameter / 2, context))),
          child: profileUrl.isNotEmpty
              ? fileImage != null
                  ? Image.file(
                      fileImage!,
                      fit: BoxFit.cover,
                    )
                  : uintList != null
                      ? Image.memory(
                          uintList!,
                          fit: BoxFit.cover,
                        )
                      : enableProfileHero
                          ? Hero(
                              tag: "profile",
                              child: CachedNetworkImage(
                                imageUrl: profileUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: profileUrl,
                              fit: BoxFit.cover,
                            )
              : Container(),
        ),
      ),
    );
  }
}
