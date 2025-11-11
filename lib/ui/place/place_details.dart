import 'dart:convert';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/wishlist.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/colors.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/gallery/all_images.dart';
import 'package:localguider/ui/gallery/horizontal_image_list.dart';
import 'package:localguider/ui/reviews/review_on_details.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:readmore/readmore.dart';

import '../photographers/photographer_horizontal_list.dart';
import '../search/view_all_contents.dart';

class PlaceDetails extends StatefulWidget {
  PlaceModel placeModel;

  Function() refreshCallback;

  PlaceDetails(
      {super.key, required this.placeModel, required this.refreshCallback});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends BaseState<PlaceDetails, HomeBloc> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarBackgroundColor = colorTransparent;

  @override
  void init() {
    disableDialogLoading = true;
    _scrollController.addListener(_scrollListener);
    isLiked = $objectBox.existByObjectId("place_${widget.placeModel.id}");
  }

  var isLiked = false;
  late double expandedHeight;

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    expandedHeight = MediaQuery.of(context).size.height * 0.27;
    $logger.log(message: "Model Description =====>  ${widget.placeModel.description}");
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: expandedHeight + 80,
            child: AppImage(
              image:
                  NetworkImage(widget.placeModel.featuredImage.appendRootUrl()),
              fit: BoxFit.cover,
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                leading: CustomInkWell(
                  onTap: () => navigatePop(context),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: $styles.colors.white,
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
                            padding:
                                EdgeInsets.only(right: sizing(10, context)),
                            child: CustomText(
                              widget.placeModel.placeName ?? "",
                              color: $styles.colors.white,
                              maxLines: 1,
                              fontSize: sizing(17, context),
                            ),
                          )
                        : null,
                    titlePadding: null,
                  );
                }),
                expandedHeight: expandedHeight,
                backgroundColor: _appBarBackgroundColor,
              ),
              SliverToBoxAdapter(
                  child: Container(
                padding: EdgeInsets.only(
                    top: sizing(40, context),
                    left: sizing(20, context),
                    right: sizing(20, context),
                    bottom: sizing(25, context)),
                decoration: BoxDecoration(
                    color: $styles.colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sizing(50, context)),
                        topRight: Radius.circular(sizing(50, context))),
                    boxShadow: [
                      BoxShadow(
                          color: $styles.colors.greyLight,
                          spreadRadius: 2,
                          blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomText(
                            widget.placeModel.placeName ?? "",
                            fontSize: sizing(18, context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: FontStyles.medium,
                          ),
                        ),
                        gap(context, width: 10),
                        CustomInkWell(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                              if (isLiked) {
                                _addToWishlist(widget.placeModel);
                              } else {
                                _removeFromWishlist(widget.placeModel);
                              }
                            });
                          },
                          child: Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isLiked
                                ? $styles.colors.red
                                : $styles.colors.black,
                          ),
                        )
                      ],
                    ),
                    gap(context, height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: sizing(2, context)),
                          child: CustomText(
                            (widget.placeModel.rating?.toDouble() ?? 0.0)
                                .toStringAsFixed(1),
                          ),
                        ),
                        gap(context, width: 10),
                        RatingBar.builder(
                          initialRating:
                              widget.placeModel.rating?.toDouble() ?? 0.0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemSize: sizing(17, context),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                    gap(context, height: 10),
                    Row(
                      children: [
                        DefaultButton("Direction",
                            radius: 10,
                            padding: 8,
                            iconStart: Icon(
                              Icons.directions,
                              size: sizing(15, context),
                              color: $styles.colors.white,
                            ), onClick: () {
                          $appUtils.openUrl(widget.placeModel.mapUrl ??
                              "https://maps.google.com?q=${widget.placeModel.latitude},${widget.placeModel.longitude}");
                        }),
                        gap(context, width: 10),
                        DefaultButton("Share",
                            radius: 10,
                            padding: 8,
                            iconStart: Icon(
                              Icons.share,
                              color: $styles.colors.white,
                              size: sizing(15, context),
                            ), onClick: () {
                          $appUtils.share(
                              text:
                                  "${widget.placeModel.placeName}\n${_captionToShare()}\n\n${$appUtils.getSettings()?.shareSnippet ?? ""}");
                        }),
                      ],
                    ),
                    gap(context, height: 15),
                    CustomText(
                      "Description",
                      style: FontStyles.medium,
                      color: $styles.colors.black,
                      fontSize: sizing(17, context),
                    ),
                    gap(context, height: 5),
                    ReadMoreText(
                      widget.placeModel.description ?? "",
                      trimLines: 4,
                      colorClickableText: Colors.grey,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' View more',
                      trimExpandedText: ' View less',
                      moreStyle: $styles.text.getFontStyle(
                          color: $styles.colors.black.withOpacity(.7),
                          fontSize: Responsive.size(context, defaultTextSize)),
                    ),
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
                                title:
                                    "Images from ${widget.placeModel.placeName}",
                                userRole: UserRole.PLACE,
                                canEdit: $isAdmin,
                                dtoId: widget.placeModel.id.toString()));
                          },
                          child: CustomText($strings.viewAll),
                        )
                      ],
                    ),
                    gap(context, height: 5),
                    HorizontalImagesList(
                      placeId: widget.placeModel.id.toString(),
                    ),
                    gap(context, height: 15),
                    Row(
                      children: [
                        CustomText(
                          "Top Guiders",
                          style: FontStyles.medium,
                          color: $styles.colors.black,
                          fontSize: sizing(17, context),
                        ),
                        const Spacer(),
                        CustomInkWell(
                          onTap: () {
                            navigate(ViewAllContent(
                              searchType: SearchTypes.guider,
                              placeId: widget.placeModel.id.toString(),
                            ));
                          },
                          child: CustomText($strings.viewAll),
                        )
                      ],
                    ),
                    gap(context, height: 5),
                    PhotographerHorizontalList(
                      placeId: widget.placeModel.id.toString(),
                      userRole: UserRole.GUIDER,
                    ),
                    gap(context, height: 15),
                    Row(
                      children: [
                        CustomText(
                          "Top Photographers",
                          style: FontStyles.medium,
                          color: $styles.colors.black,
                          fontSize: sizing(17, context),
                        ),
                        const Spacer(),
                        CustomInkWell(
                          onTap: () {
                            navigate(ViewAllContent(
                                searchType: SearchTypes.photographer,
                                placeId: widget.placeModel.id.toString()));
                          },
                          child: CustomText($strings.viewAll),
                        )
                      ],
                    ),
                    gap(context, height: 5),
                    PhotographerHorizontalList(
                      placeId: widget.placeModel.id.toString(),
                      userRole: UserRole.PHOTOGRAPHER,
                    ),
                    gap(context, height: 5),
                    ReviewOnDetails(
                        placeId: widget.placeModel.id.toString(),
                        onRatingChange: (newRating) {
                          widget.refreshCallback();
                          setState(() {
                            widget.placeModel.rating = newRating;
                          });
                        })
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }

  String _captionToShare() {
    var text = widget.placeModel.description ?? "";
    if (text.length > 50) {
      text = "${text.substring(0, 49)}....";
    }
    return text;
  }

  _addToWishlist(PlaceModel model) {
    $objectBox.addWishlist(Wishlist(
        title: model.placeName,
        subTitle: model.state,
        type: UserRole.PLACE.name,
        image: model.featuredImage,
        objectId: "place_${model.id}",
        date: DateTime.now(),
        data: jsonEncode(model.toJson())));
  }

  _removeFromWishlist(PlaceModel model) {
    $objectBox.deleteByObjectId("place_${model.id}");
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      final appBarCollapseHeight = expandedHeight - kToolbarHeight;
      if (offset >= appBarCollapseHeight) {
        if (_appBarBackgroundColor != $styles.colors.blue) {
          setState(() {
            _appBarBackgroundColor = $styles.colors.blue;
          });
        }
      } else {
        if (_appBarBackgroundColor != colorTransparent) {
          setState(() {
            _appBarBackgroundColor = colorTransparent;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
