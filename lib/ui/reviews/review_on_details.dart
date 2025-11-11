import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/modals/rating_modal.dart';
import 'package:localguider/models/response/review_dto.dart';
import 'package:localguider/style/colors.dart';
import 'package:localguider/ui/rows/row_review.dart';
import 'package:localguider/utils/app_state.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../../style/styles.dart';
import 'all_reviews.dart';

class ReviewOnDetails extends StatefulWidget {
  String? placeId;
  String? photographerId;
  String? guiderId;

  bool showInDashboard;
  Function(double newRating) onRatingChange;
  ReviewOnDetails(
      {super.key, this.placeId, this.photographerId, this.guiderId, this.showInDashboard = false, required this.onRatingChange});

  @override
  State<ReviewOnDetails> createState() => _ReviewOnDetailsState();
}

class _ReviewOnDetailsState extends BaseState<ReviewOnDetails, HomeBloc> {
  List<ReviewDto> reviews = [];
  bool? canGiveReview ;

  AppState _state = AppState.FETCHING_DATA;

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  void postFrame() {
    super.postFrame();
    bloc.getReviews(user.id.toString(), widget.photographerId, widget.guiderId, widget.placeId, null);
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    $logger.log(message: ">>>>>>>>>>>>>>>>  ${!widget.showInDashboard} $canGiveReview ${!widget.showInDashboard && canGiveReview == true}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       if(!widget.showInDashboard && canGiveReview == true)  CustomText(
          "Give a Review",
          style: FontStyles.medium,
          color: $styles.colors.black,
          fontSize: sizing(17, context),
        ),
        if(!widget.showInDashboard && canGiveReview == true) gap(context, height: 10),
        if(!widget.showInDashboard && canGiveReview == true) Center(
          child: RatingBar.builder(
            initialRating: 0.0,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: sizing(50, context),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              Get.dialog(
                  barrierDismissible: true,
                  Dialog(
                    backgroundColor: $styles.colors.white,
                    child: RatingModal(
                        rating: rating,
                        callback: (rating, message) {
                          disableDialogLoading = false;
                          _addReview(rating, message);
                        }),
                  ));
            },
          ),
        ),
        if(!widget.showInDashboard && canGiveReview == true) gap(context, height: 10),
        if(!widget.showInDashboard) Row(
          children: [
            CustomText(
              "Reviews",
              style: FontStyles.medium,
              color: $styles.colors.black,
              fontSize: sizing(17, context),
            ),
            const Spacer(),
            InkWell(
                onTap: () {
                  navigate(AllReviews(
                    photographerId: widget.photographerId,
                    guiderId: widget.guiderId,
                    placeId: widget.placeId,
                  ));
                },
                child: CustomText("View All",
                    color: $styles.colors.blue,
                    isBold: true,
                    fontSize: sizing(16, context))),
          ],
        ),
        if(!widget.showInDashboard && canGiveReview == true) gap(context, height: 10),
        _state == AppState.FETCHING_DATA
            ? Padding(
                padding: EdgeInsets.all(sizing(15, context)),
                child: Center(
                  child: CircularProgressIndicator(
                    color: $styles.colors.blue,
                  ),
                ),
              )
            : reviews.isEmpty ? Center(child: CustomText("No reviews yet")) : ListView.builder(
                itemBuilder: (context, index) =>
                    RowReview(review: reviews[index]),
                itemCount: reviews.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
      ],
    );
  }

  _addReview(rating, message) {
    bloc.addReview(widget.photographerId, widget.guiderId, widget.placeId,
        user.id.toString(), rating, message);
  }

  @override
  void observer() {
    bloc.reviewsStream.stream.listen((event) {
      disableDialogLoading = true;
      setState(() {
        _state = AppState.DATA_READY;
        canGiveReview = event?.canGiveReview ?? true;
        reviews = event?.data ?? [];
      });
    });
    bloc.addReviewStream.stream.listen((event) {
      bloc.getReviews(user.id.toString(), widget.photographerId, widget.guiderId, widget.placeId, null);
      widget.onRatingChange(event?.data?.newRating?.toDouble() ?? 0.0);
    });
    super.observer();
  }
}
