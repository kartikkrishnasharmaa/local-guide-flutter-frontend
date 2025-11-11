import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/app_image.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../../style/styles.dart';

class RowWishlist extends StatefulWidget {

  String? title;
  String? subtitle;
  String? imageUrl;
  Function onClick;
  Function(bool isFav) onFavClick;

  RowWishlist(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.onClick, required this.onFavClick});

  @override
  State<RowWishlist> createState() => _RowWishlistState();
}

class _RowWishlistState extends State<RowWishlist> {

  var isLiked = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Padding(
        padding: EdgeInsets.all(sizing(10, context)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: $styles.colors.black, width: 1),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  gap(context, height: 5),
                  CustomText(
                    widget.title ?? "Unknown",
                    color: $styles.colors.black,
                    style: FontStyles.medium,
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
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  gap(context, height: 5),
                  CustomInkWell(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                        widget.onFavClick(isLiked);
                      });
                    },
                    child: Icon(
                      isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      color: isLiked ? $styles.colors.red : $styles.colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
