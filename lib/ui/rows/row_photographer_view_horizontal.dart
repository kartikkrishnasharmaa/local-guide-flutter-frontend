import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/app_image.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../models/response/photographer_dto.dart';
import '../../responsive.dart';
import '../../style/styles.dart';

class RowPhotographerViewHorizontal extends StatelessWidget {
  PhotographerDto photographer;
  Function onClick;
  RowPhotographerViewHorizontal({super.key, required this.photographer, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: () {
        onClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          borderRadius: BorderRadius.circular(
              sizing($appUtils.defaultCornerRadius, context)),
          color: $styles.colors.white,
          elevation: sizing(3.0, context),
          child: SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: sizing(100, context),
                  width: sizing(120, context),
                  child: Padding(
                    padding: EdgeInsets.all(sizing(8, context)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            sizing($appUtils.defaultCornerRadius, context)),
                        child: AppImage(
                          image: NetworkImage(
                              photographer.featuredImage.appendRootUrl()),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sizing(5, context), right: sizing(5, context)),
                  child: CustomText(
                    photographer.firmName ?? '',
                    maxLines: 1,
                    fontSize: sizing(12, context),
                    style: FontStyles.medium,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sizing(5, context),
                      right: sizing(5, context),
                      bottom: sizing(5, context)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: $styles.colors.blue,
                        size: sizing(12, context),
                      ),
                      CustomText(
                        photographer.placeName ?? '',
                        maxLines: 1,
                        color: $styles.colors.blue,
                        fontSize: sizing(10, context),
                      ),
                    ],
                  ),
                ),
                RatingBar.builder(
                  initialRating: photographer.rating?.toDouble() ?? 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  tapOnlyMode: true,
                  itemSize: sizing(13, context),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
