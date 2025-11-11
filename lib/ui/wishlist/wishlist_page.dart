import 'dart:convert';

import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/wishlist.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/place/place_details.dart';
import 'package:localguider/ui/wishlist/row_wishlist.dart';
import 'package:localguider/user_role.dart';

import '../../common_libs.dart';
import '../photographers/photographer_details.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Wishlist> list = [];

  @override
  void initState() {
    list = $objectBox.getWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            "Your Wishlist",
            color: $styles.colors.white,
            fontSize: titleSize(),
          ),
        ),
        body: list.isEmpty
            ? Padding(
                padding: EdgeInsets.all(
                  sizing(40, context),
                ),
                child: Center(
                    child: CircularProgressIndicator(
                  color: $styles.colors.blue,
                )),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Wishlist item = list[index];
                  return RowWishlist(
                      title: item.title,
                      subtitle: item.subTitle,
                      imageUrl: item.image,
                      onClick: () {
                        if(item.type == UserRole.PLACE.name) {
                          PlaceModel data = PlaceModel.fromJson(json.decode(item.data!));
                          navigate(PlaceDetails(placeModel: data, refreshCallback: () {

                          }));
                        } else if(item.type == UserRole.PHOTOGRAPHER.name) {
                          PhotographerDto data = PhotographerDto.fromJson(json.decode(item.data!));
                          navigate(PhotographerDetails(dto: data, userRole: UserRole.PHOTOGRAPHER, refreshCallback: () {},));
                        } else if(item.type == UserRole.GUIDER.name) {
                          PhotographerDto data = PhotographerDto.fromJson(json.decode(item.data!));
                          navigate(PhotographerDetails(dto: data, userRole: UserRole.GUIDER,refreshCallback: () {},));
                        }
                      }, onFavClick: (b) {
                        if(b) {
                          $objectBox.addWishlist(item);
                        } else {
                          $objectBox.deleteById(item.id);
                        }
                  },);
                }));
  }
}
