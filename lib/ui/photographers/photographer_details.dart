import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/style/colors.dart';
import 'package:localguider/ui/appointments/book_appointment.dart';
import 'package:localguider/ui/gallery/view_image.dart';
import 'package:localguider/ui/reviews/review_on_details.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/values/assets.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../models/wishlist.dart';
import '../../responsive.dart';
import '../../style/styles.dart';
import '../../user_role.dart';
import '../gallery/all_images.dart';
import '../gallery/horizontal_image_list.dart';

class PhotographerDetails extends StatefulWidget {
  PhotographerDto dto;
  UserRole userRole;
  Function() refreshCallback;
  PhotographerDetails({super.key, required this.dto, required this.userRole, required this.refreshCallback});

  @override
  State<PhotographerDetails> createState() => _PhotographerDetailsState();
}

class _PhotographerDetailsState extends State<PhotographerDetails> {
  var isLiked = false;

  @override
  void initState() {
    isLiked =
        $objectBox.existByObjectId("${widget.userRole.name}_${widget.dto.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const expandedHeight = 200.0;
    return Scaffold(
      backgroundColor: $styles.colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: $styles.colors.blue,
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            pinned: true,
            leading: IconButton(
              onPressed: () => navigatePop(context),
              icon: Container(
                width: sizing(30, context),
                height: sizing(30, context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sizing(15, context)),
                    color: $styles.colors.white),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: $styles.colors.blue,
                  ),
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              final fraction =
                  max(0, constraints.biggest.height - kToolbarHeight) /
                      (expandedHeight - kToolbarHeight);
              return FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                title: fraction < 0.5
                    ? Padding(
                        padding: EdgeInsets.only(right: sizing(10, context)),
                        child: CustomText(
                          widget.dto.firmName ?? "",
                          color: $styles.colors.blue,
                          maxLines: 1,
                          fontSize: sizing(17, context),
                        ),
                      )
                    : null,
                titlePadding: null,
                background: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 150,
                        child: AppImage(
                          image: AssetImage(Images.waveBg),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                        right: 30,
                        top: 50,
                        child: InkWell(
                          onTap: () {
                            navigate(ViewImage(imageUrl: widget.dto.featuredImage.appendRootUrl()));
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.blue],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(47)),
                            child: Center(
                              child: ProfileView(
                                  diameter: 80,
                                  outerStrokeWidth: 0,
                                  enableProfileHero: true,
                                  strokeGap: 0,
                                  outerStrokeColor: $styles.colors.white,
                                  profileUrl:
                                      widget.dto.featuredImage.appendRootUrl()),
                            ),
                          ),
                        )),
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            widget.dto.firmName ?? "",
                            fontSize: sizing(17, context),
                            isBold: true,
                          ),
                          gap(context, height: 10),
                          RatingBar.builder(
                            initialRating: widget.dto.rating?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemSize: sizing(25, context),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 155,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                            if (isLiked) {
                              _addToWishlistPhotographer(
                                  widget.dto, widget.userRole.name);
                            } else {
                              _removeFromWishlistPhotographer(
                                  widget.dto, widget.userRole.name);
                            }
                          });
                        },
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(
                              $appUtils.defaultCornerRadius),
                          child: SizedBox(
                            height: sizing(50, context),
                            width: sizing(50, context),
                            child: Icon(
                              isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: isLiked ? $styles.colors.red : $styles.colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
            expandedHeight: expandedHeight,
            backgroundColor: $styles.colors.white,
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.all(sizing(10, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (widget.dto.phone != null)
                //   _listTile(
                //       Icon(
                //         Icons.phone_android,
                //         color: $styles.colors.blue,
                //       ),
                //       widget.dto.phone ?? "",
                //       () => null),
                if (widget.dto.email != null)
                  _listTile(
                      Icon(
                        Icons.email_outlined,
                        color: $styles.colors.blue,
                      ),
                      widget.dto.email ?? "",
                      () => null),
                if (widget.dto.placeName != null)
                  _listTile(
                      Icon(
                        Icons.location_pin,
                        color: $styles.colors.blue,
                      ),
                      widget.dto.placeName ?? "",
                      () => null),
                gap(context, height: 15),
                if(widget.dto.active != true) Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline_rounded, color: $styles.colors.red,),
                      gap(context, width: 10),
                      CustomText("Not Accepting Appointments Right Now", color: $styles.colors.red,)
                    ],
                  ),
                ),
                if(widget.dto.active == true) DefaultButton("Book Now", radius: 10, onClick: () {
                  navigate(BookAppointment(
                    dto: widget.dto,
                    userRole: widget.userRole,
                  ));
                }),
                gap(context, height: 15),
                Row(
                  children: [
                    CustomText(
                      "Photos",
                      style: FontStyles.medium,
                      color: $styles.colors.black,
                      fontSize: sizing(17, context),
                    ),
                    const Spacer(),
                    CustomInkWell(
                      onTap: () {
                        navigate(AllImages(
                            title: "Images by ${widget.dto.firmName}",
                            userRole: widget.userRole,
                            dtoId: widget.dto.id.toString()));
                      },
                      child: CustomText($strings.viewAll),
                    )
                  ],
                ),
                gap(context, height: 5),
                HorizontalImagesList(
                  photographerId: widget.userRole == UserRole.PHOTOGRAPHER ? widget.dto.id.toString() : null,
                  guiderId: widget.userRole == UserRole.GUIDER ? widget.dto.id.toString() : null,
                ),
                gap(context, height: 15),
                ReviewOnDetails(
                  photographerId: widget.userRole == UserRole.PHOTOGRAPHER ? widget.dto.id.toString() : null,
                  guiderId: widget.userRole == UserRole.GUIDER ? widget.dto.id.toString() : null,
                  onRatingChange: (newRating) {
                    widget.refreshCallback();
                    setState(() {
                      widget.dto.rating = newRating;
                    });
                  },
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  _listTile(Widget image, title, Function() onClick, {color}) {
    return CustomInkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sizing(10, context)),
        child: Row(
          children: [
            SizedBox(
              height: sizing(20, context),
              width: sizing(20, context),
              child: image,
            ),
            gap(context, width: 10),
            CustomText(
              title,
              isBold: true,
            )
          ],
        ),
      ),
      onTap: () {
        onClick();
      },
    );
  }

  _addToWishlistPhotographer(PhotographerDto model, type) {
    $objectBox.addWishlist(Wishlist(
        title: model.firmName,
        subTitle: model.placeName,
        type: type,
        image: model.featuredImage,
        objectId: type + "_" + model.id.toString(),
        date: DateTime.now(),
        data: jsonEncode(model.toJson())));
  }

  _removeFromWishlistPhotographer(PhotographerDto model, type) {
    $objectBox.deleteByObjectId(type + "_" + model.id.toString());
  }
}
