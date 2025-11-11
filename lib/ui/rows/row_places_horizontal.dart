import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/app_image.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../../style/styles.dart';
import '../place/place_details.dart';

class RowPlacesHorizontal extends StatelessWidget {

  PlaceModel place;
  Function() refreshCallback;
  RowPlacesHorizontal({super.key, required this.place, required this.refreshCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomInkWell(
        onTap: () {
          navigate(PlaceDetails(placeModel: place, refreshCallback: () {
            refreshCallback();
          },));
        },
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(
              sizing($appUtils.defaultCornerRadius, context)),
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              color: $styles.colors.white,
              borderRadius: BorderRadius.circular(
                  sizing($appUtils.defaultCornerRadius, context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: sizing(100, context),
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.all(sizing(8, context)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            sizing($appUtils.defaultCornerRadius, context)),
                        child: AppImage(
                          image: NetworkImage(
                              place.featuredImage.appendRootUrl()),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sizing(5, context), right: sizing(5, context)),
                  child: CustomText(
                    place.placeName ?? "",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: $styles.colors.blue,
                        size: sizing(12, context),
                      ),
                      CustomText(
                        place.state ?? "",
                        maxLines: 1,
                        color: $styles.colors.blue,
                        fontSize: sizing(10, context),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sizing(5, context), right: sizing(5, context)),
                  child: RatingBar.builder(
                    initialRating: place.rating?.toDouble() ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemSize: sizing(13, context),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
