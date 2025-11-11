import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/review_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/utils/time_utils.dart';

import '../../common_libs.dart';

class RowReview extends StatefulWidget {
  ReviewDto review;

  RowReview({super.key, required this.review});

  @override
  State<RowReview> createState() => _RowReviewState();
}

class _RowReviewState extends State<RowReview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizing(5, context)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: sizing(30, context), right: sizing(10, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RatingBar.builder(
                    initialRating: widget.review.rating?.toDouble() ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemSize: sizing(14, context),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  gap(context, height: 2),
                  CustomText(
                    widget.review.lastUpdate != null
                        ? TimeUtils.format(
                            TimeUtils.parseUtcToLocal(widget.review.lastUpdate),
                            format: TimeUtils.dd_MM_yyyy)
                        : "",
                    fontSize: 9,
                    color: $styles.colors.blue,
                    style: FontStyles.regular,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: sizing(25, context)),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(sizing(10, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizing(20, context)),
                  border: Border.all(
                    color: $styles.colors.blue,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    gap(context, height: 5),
                    Row(
                      children: [
                        const Spacer(),
                        CustomText(
                          widget.review.fullName ?? "Unknown",
                          color: $styles.colors.blue,
                          style: FontStyles.medium,
                          isBold: true,
                        ),
                        gap(context, width: 5),
                        const Spacer(),
                      ],
                    ),
                    gap(context, height: 5),
                    if (widget.review.message != null)
                      CustomText(
                        widget.review.message ?? "",
                        color: $styles.colors.blue,
                        fontSize: 12,
                        style: FontStyles.regular,
                      ),
                    gap(context, height: 5),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: sizing(20, context)),
            child: ProfileView(
                diameter: 50,
                profileUrl: widget.review.profileImage.appendRootUrl()),
          ),
        ],
      ),
    );
  }
}
