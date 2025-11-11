import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/ui/admin/places/add_edit_place.dart';
import 'package:localguider/ui/reviews/review_on_details.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_libs.dart';
import '../../../components/custom_ink_well.dart';
import '../../../components/custom_text.dart';
import '../../../main.dart';
import '../../../responsive.dart';
import '../../../style/styles.dart';
import '../../../user_role.dart';
import '../../gallery/all_images.dart';
import '../../gallery/horizontal_image_list.dart';

class PlaceDetailsAdmin extends StatefulWidget {
  PlaceModel placeModel;
  Function() refreshCallback;
  PlaceDetailsAdmin({super.key, required this.placeModel, required this.refreshCallback});

  @override
  State<PlaceDetailsAdmin> createState() => _PlaceDetailsAdminState();
}

class _PlaceDetailsAdminState extends BaseState<PlaceDetailsAdmin, HomeBloc> {
  @override
  void init() {

  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        centerTitle: true,
        title: CustomText(
          widget.placeModel.placeName ?? "",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigate(AddEditPlace(
                  refreshCallback: (p0) {
                    setState(() {
                      widget.placeModel = p0;
                    });
                  },
                  placeModel: widget.placeModel,
                ));
              },
              icon: Icon(
                Icons.edit,
                color: $styles.colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sizing(20, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText("Feature Image"),
            gap(context, height: 10),
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(sizing(10, context)),
                  child: AppImage(
                      image: NetworkImage(
                          widget.placeModel.featuredImage.appendRootUrl()))),
            ),
            gap(context, height: 20),
            CustomText("Place name"),
            gap(context, height: 10),
            CustomText(widget.placeModel.placeName ?? "N/A", fontSize: 16, color: $styles.colors.blue,),
            gap(context, height: 20),
            CustomText("City"),
            gap(context, height: 10),
            CustomText(widget.placeModel.city ?? "N/A", fontSize: 16, color: $styles.colors.blue,),
            gap(context, height: 20),
            CustomText("State"),
            gap(context, height: 10),
            CustomText(widget.placeModel.state ?? "N/A", fontSize: 16, color: $styles.colors.blue,),
            gap(context, height: 20),
            CustomText("Full Address"),
            gap(context, height: 10),
            CustomText(widget.placeModel.fullAddress ?? "N/A", fontSize: 16, color: $styles.colors.blue,),
            gap(context, height: 20),
            CustomText("Map URL"),
            gap(context, height: 10),
            CustomInkWell(
              onTap: () {
                $appUtils.openUrl(widget.placeModel.mapUrl ?? "");
              },
                child: CustomText(widget.placeModel.mapUrl ?? "N/A", isUnderline: true, fontSize: 16, color: $styles.colors.blue,)),
            gap(context, height: 20),
            Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    CupertinoSwitch(value: widget.placeModel.isTop ?? false, onChanged: null),
                    gap(context, width: 10),
                    CustomText("Top Place",),
                  ],
                )),
            gap(context, height: 20),
            CustomText("Description"),
            gap(context, height: 10),
            CustomText(widget.placeModel.description ?? "", fontSize: 16, color: $styles.colors.blue,),
            gap(context, height: 20),
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
                        title: "Images from ${widget.placeModel.placeName}",
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
            ReviewOnDetails(placeId: widget.placeModel.id.toString(), onRatingChange: (newRating) {
              widget.refreshCallback();
              setState(() {
                widget.placeModel.rating = newRating;
              });
            })
          ],
        ),
      ),
    );
  }

}
