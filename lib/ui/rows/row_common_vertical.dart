import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';

class RowCommonVertical extends StatefulWidget {
  String title;
  String subtitle;
  double rating;
  String imageUrl;
  bool inAdmin = false;
  Function onClick;
  String likeObjId;
  bool selected;
  bool showResponseButton = false;
  bool showDeleteButton = false;
  Function(bool approve, bool decline)? onResponse;
  Function(bool)? onFavClick;
  Function? onDelete;

  RowCommonVertical(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.rating,
      required this.imageUrl,
      this.inAdmin = false,
      required this.onClick,
      required this.likeObjId,
        this.selected = false,
      this.onResponse,
      this.onDelete,
      this.showResponseButton = false,
      this.showDeleteButton = false,
      this.onFavClick});
  
  @override
  State<RowCommonVertical> createState() => _RowCommonVerticalState();
}

class _RowCommonVerticalState extends State<RowCommonVertical> {
  var isLiked = false;
  
  @override
  void initState() {
    isLiked = $objectBox.existByObjectId(widget.likeObjId);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    $logger.log(message: widget.imageUrl.appendRootUrl());

    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Padding(
        padding: EdgeInsets.all(sizing(10, context)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: widget.selected ? $styles.colors.green : $styles.colors.black, width: widget.selected ? 2 : 1),
            borderRadius: BorderRadius.circular(sizing(10, context)),
          ),
          padding: EdgeInsets.only(
              top: sizing(7, context),
              bottom: sizing(7, context),
              right: sizing(7, context)),
          child: Row(
            children: [
              Container(
                width: sizing(70, context),
                height: sizing(60, context),
                padding: EdgeInsets.only(left: sizing(7, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizing(10, context)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sizing(10, context)),
                  child: AppImage(
                    image: NetworkImage(widget.imageUrl.appendRootUrl()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              gap(context, width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    gap(context, height: 5),
                    CustomText(
                      widget.title ?? "Unknown",
                      color: $styles.colors.black,
                      style: FontStyles.medium,
                      maxLines: 2,
                      isBold: true,
                    ),
                    gap(context, width: 5),
                    gap(context, height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: $styles.colors.black,
                          size: sizing(15, context),
                        ),
                        CustomText(
                          widget.subtitle ?? "",
                          color: $styles.colors.black,
                          fontSize: 12,
                          style: FontStyles.regular,
                        ),
                      ],
                    ),
                    gap(context, height: 5),
                  ],
                ),
              ),
              gap(context, width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!widget.showResponseButton)
                    RatingBar.builder(
                      initialRating: widget.rating ?? 0.0,
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
                  gap(context, height: 5),
                  if (!widget.inAdmin)
                    CustomInkWell(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                          if (widget.onFavClick != null) {
                            widget.onFavClick!(isLiked);
                          }
                        });
                      },
                      child: Icon(
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color:
                            isLiked ? $styles.colors.red : $styles.colors.black,
                      ),
                    ),
                  if (widget.inAdmin && widget.showResponseButton)
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              if (widget.onResponse != null) {
                                widget.onResponse!(true, false);
                              }
                            },
                            icon: Icon(
                              Icons.check_rounded,
                              color: $styles.colors.green,
                            )),
                        gap(context, width: 5),
                        IconButton(
                            onPressed: () {
                              if (widget.onResponse != null) {
                                widget.onResponse!(false, true);
                              }
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: $styles.colors.red,
                            )),
                      ],
                    ),
                  if (widget.showDeleteButton) gap(context, width: 10),
                  if (widget.showDeleteButton)
                    IconButton(
                        onPressed: () {
                          widget.onDelete!();
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          color: $styles.colors.red,
                        ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
