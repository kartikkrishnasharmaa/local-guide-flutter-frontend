import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';

import '../../../common_libs.dart';

class RowButton extends StatelessWidget {

  String image;
  String title;
  String subtitle;
  Function() onClick;

  RowButton(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(sizing(10, context)),
          decoration: BoxDecoration(
            color: $styles.colors.blueSurface,
            borderRadius: BorderRadius.circular(sizing(15, context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                    width: sizing(50, context),
                    height: sizing(50, context),
                    child: AppImage(image: AssetImage(image))),
              ),
              gap(context, height: 5),
              CustomText(
                title,
                color: $styles.colors.black,
                fontSize: 15,
                maxLines: 1,
                isBold: true,
              ),
              gap(context, height: 5),
              CustomText(
                subtitle,
                color: $styles.colors.greyStrong,
                maxLines: 1,
                fontSize: sizing(10, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
