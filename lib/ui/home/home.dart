import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/auth_bloc.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/svg_image.dart';
import 'package:localguider/models/requests/update_user_request_dto.dart';
import 'package:localguider/models/response/home_response_dto.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/colors.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/rows/row_photographer_view_horizontal.dart';
import 'package:localguider/ui/rows/row_places_horizontal.dart';
import 'package:localguider/ui/search/search_content.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/ui/search/view_all_contents.dart';
import 'package:localguider/ui/settings/notifications.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/values/assets.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../maps/places_response.dart';
import '../../modals/find_places.dart';
import '../authentication/user_information.dart';
import '../photographers/photographer_details.dart';
import '../settings/blocked.dart';
import 'home_drawer.dart';

StreamController<bool?> infoUpdated = StreamController.broadcast();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseState<Home, HomeBloc> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomeResponseDto? home;

  String address = "";

  int unreadNotifications = 0;

  @override
  void init() {
    address = user.address ?? "";
    disableDialogLoading = true;
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  void postFrame() {
    super.postFrame();
    _getData();
    checkPermissions(context, Permission.notification, (p0) {
      if (p0) {}
    });
    infoUpdated.stream.listen((event) {
      if(event == null) return;
      if(event) {
        setState(() {
          address = user.address ?? "";
        });
        infoUpdated.add(null);
      }
    });
    _determinePosition();
    // if(user.address == "New Delhi, India,") {
    //   _determinePosition();
    // }
  }

  _getData() {
    bloc.getHomeDetails(user.id);
    bloc.getProfile(user.id.toString());
    _getSettings();
  }

  @override
  Widget view() {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: $styles.colors.blueBg,
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: $styles.colors.blue,
          title: Row(
            children: [
              CustomInkWell(
                  child: Icon(
                    Icons.menu_rounded,
                    color: $styles.colors.white,
                  ),
                  onTap: () => scaffoldKey.currentState?.openDrawer()),
              gap(context, width: 10),
              CustomText(
                "Hi, ${user.name != null ? user.name?.split(" ").first : ""}",
                isBold: true,
                color: $styles.colors.white,
              ),
              const Spacer(),
              CustomInkWell(
                onTap: () {
                  navigate(FindPlaces(
                    onPlaceSelected: (Predictions? place, LatLng? latLng) {
                      _onPlaceSelected(place, latLng);
                    },
                  ));
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: sizing(100, context),
                      child: CustomText(
                        address,
                        maxLines: 1,
                        isBold: true,
                        align: TextAlign.right,
                        color: $styles.colors.white,
                      ),
                    ),
                    gap(context, width: 10),
                    CustomInkWell(
                        child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: $styles.colors.white,
                    ))
                  ],
                ),
              ),
              gap(context, width: 10),
              CustomInkWell(
                  onTap: () {
                    navigate(UserInformation(phone: "", password: "", userData: user, isEditProfile: true, onUpdate: (user) {
                      $user.saveDetails(user);
                      home = null;
                      _getData();
                    },));
                    // navigate(const EditProfile());
                  },
                  child: Icon(
                    Icons.person,
                    color: $styles.colors.white,
                  )),
              gap(context, width: 10),
              CustomInkWell(
                  onTap: () {
                    navigate(Notifications(
                      userRole: UserRole.JUST_USER,
                      dtoId: user.id.toString(),
                      refreshCallback: () {
                        _getSettings();
                      },
                    ));
                  },
                  child: unreadNotifications > 0
                      ? Badge(
                          label: Text(unreadNotifications.toString()),
                          child: Icon(
                            Icons.notifications,
                            color: $styles.colors.white,
                          ),
                        )
                      : Icon(
                          Icons.notifications,
                          color: $styles.colors.white,
                        )),
            ],
          ),
          leading: Container(),
          leadingWidth: 0,
        ),
        drawer: Drawer(
            backgroundColor: $styles.colors.white, child: const HomeDrawer()),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            setState(() {
              home = null;
              _getData();
            });
          }),
          child: SafeArea(
            child: SingleChildScrollView(
              child: home == null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(sizing(40, context)),
                        child: CircularProgressIndicator(
                          color: $styles.colors.blue,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.maxFinite,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(200),
                                    bottomRight: Radius.circular(200),
                                  ),
                                  child: AppImage(
                                    image: AssetImage(Images.icHawamahal),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(200),
                                    bottomRight: Radius.circular(200),
                                  ),
                                  color: $styles.colors.blue.withOpacity(.75),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      "Welcome to INDIA!",
                                      color: $styles.colors.yellow,
                                      fontSize: sizing(17, context),
                                      style: FontStyles.medium,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sizing(25, context),
                                          right: sizing(25, context),
                                          top: sizing(10, context)),
                                      child: InputField(
                                          hint: $strings.searchOrExploreHere,
                                          isNumeric: true,
                                          padding: 7,
                                          isDisable: true,
                                          onClick: () {
                                            navigate(SearchContent(
                                              searchType: SearchTypes.place,
                                            ));
                                          },
                                          disableLabel: true,
                                          radius: sizing(30, context),
                                          iconStart: Icon(
                                            Icons.search_rounded,
                                            color: $styles.colors.blue,
                                          ),
                                          maxLength: 10,
                                          bgColor: $styles.colors.white,
                                          controller: TextEditingController()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        gap(context, height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(sizing(15, context)),
                            child: CustomText(
                              "What you would \nlike to find ?",
                              fontSize: 18,
                              style: FontStyles.medium,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigate(SearchContent(
                                      searchType: SearchTypes.place));
                                },
                                child: Center(
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(
                                        sizing(25, context)),
                                    child: SizedBox(
                                      height: sizing(50, context),
                                      width: sizing(50, context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            sizing(25, context)),
                                        child: AppImage(
                                            image: AssetImage(Images.icPlace)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigate(SearchContent(
                                      searchType: SearchTypes.guider));
                                },
                                child: Center(
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(
                                        sizing(25, context)),
                                    child: SizedBox(
                                      height: sizing(50, context),
                                      width: sizing(50, context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            sizing(25, context)),
                                        child: AppImage(
                                            image: AssetImage(
                                                Images.icGuiderHome)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigate(SearchContent(
                                      searchType: SearchTypes.photographer));
                                },
                                child: Center(
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(
                                        sizing(25, context)),
                                    child: SizedBox(
                                      height: sizing(50, context),
                                      width: sizing(50, context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            sizing(25, context)),
                                        child: AppImage(
                                            image: AssetImage(
                                                Images.icPhotographersHome)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Center(
                            //     child: Material(
                            //       elevation: 3,
                            //       borderRadius: BorderRadius.circular(
                            //           sizing(25, context)),
                            //       child: SizedBox(
                            //         height: sizing(50, context),
                            //         width: sizing(50, context),
                            //         child: ClipRRect(
                            //           borderRadius: BorderRadius.circular(
                            //               sizing(25, context)),
                            //           child: AppImage(
                            //               image: AssetImage(Images.icMoreHome)),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        gap(context, height: sizing(10, context)),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: CustomText($strings.places,
                                    fontSize: sizing(10, context),
                                    isBold: true,
                                    color: $styles.colors.black),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: CustomText($strings.guiders,
                                    isBold: true,
                                    fontSize: sizing(10, context),
                                    color: $styles.colors.black),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: CustomText($strings.photographers,
                                    isBold: true,
                                    fontSize: sizing(10, context),
                                    color: $styles.colors.black),
                              ),
                            ),
                            // Expanded(
                            //   child: Center(
                            //     child: CustomText($strings.more,
                            //         isBold: true,
                            //         fontSize: sizing(10, context),
                            //         color: $styles.colors.black),
                            //   ),
                            // ),
                          ],
                        ),
                        gap(context, height: 15),
                        Row(
                          children: [
                            gap(context, width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  $strings.explore,
                                  maxLines: 1,
                                  fontSize: 18,
                                  style: FontStyles.medium,
                                ),
                                CustomText(
                                  $strings.nearByPlaces,
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(10, context),
                                  color: $styles.colors.black,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomInkWell(
                                onTap: () {
                                  navigate(ViewAllContent(
                                      searchType: SearchTypes.place));
                                },
                                child: CustomText(
                                  $strings.viewAll,
                                  isBold: true,
                                )),
                            gap(context, width: 15),
                          ],
                        ),
                        gap(context, height: 10),
                        Container(
                          height: 175,
                          padding: EdgeInsets.only(
                              left: sizing(5, context),
                              right: sizing(5, context)),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return RowPlacesHorizontal(
                                place: home!.places![index],
                                refreshCallback: () {
                                  bloc.getHomeDetails(user.id);
                                },
                              );
                            },
                            itemCount: home!.places?.length ?? 0,
                          ),
                        ),
                        gap(context, height: 15),
                        Row(
                          children: [
                            gap(context, width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  $strings.topGuiders,
                                  maxLines: 1,
                                  fontSize: 18,
                                  style: FontStyles.medium,
                                ),
                                CustomText(
                                  $strings.sortedByRating,
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(10, context),
                                  color: $styles.colors.black,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomInkWell(
                                onTap: () {
                                  navigate(ViewAllContent(
                                      searchType: SearchTypes.guider));
                                },
                                child: CustomText(
                                  $strings.viewAll,
                                  isBold: true,
                                )),
                            gap(context, width: 15),
                          ],
                        ),
                        Container(
                          height: 175,
                          padding: EdgeInsets.only(
                              left: sizing(5, context),
                              right: sizing(5, context)),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              PhotographerDto guider = home!.guiders![index];
                              return RowPhotographerViewHorizontal(
                                photographer: guider,
                                onClick: () {
                                  navigate(PhotographerDetails(
                                    dto: guider,
                                    userRole: UserRole.GUIDER,
                                    refreshCallback: () {
                                      bloc.getHomeDetails(user.id);
                                    },
                                  ));
                                },
                              );
                            },
                            itemCount: home!.guiders?.length ?? 0,
                          ),
                        ),
                        gap(context, height: 15),
                        Row(
                          children: [
                            gap(context, width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  $strings.topPhotographers,
                                  maxLines: 1,
                                  fontSize: 18,
                                  style: FontStyles.medium,
                                ),
                                CustomText(
                                  $strings.sortedByRating,
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(10, context),
                                  color: $styles.colors.black,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomInkWell(
                                onTap: () {
                                  navigate(ViewAllContent(
                                      searchType: SearchTypes.photographer));
                                },
                                child: CustomText(
                                  $strings.viewAll,
                                  isBold: true,
                                )),
                            gap(context, width: 15),
                          ],
                        ),
                        Container(
                          height: 175,
                          padding: EdgeInsets.only(
                              left: sizing(5, context),
                              right: sizing(5, context)),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              PhotographerDto photographer =
                                  home!.photographers![index];
                              return RowPhotographerViewHorizontal(
                                photographer: photographer,
                                onClick: () {
                                  navigate(PhotographerDetails(
                                    dto: photographer,
                                    userRole: UserRole.PHOTOGRAPHER,
                                    refreshCallback: () {
                                      bloc.getHomeDetails(user.id);
                                    },
                                  ));
                                },
                              );
                            },
                            itemCount: home!.photographers?.length ?? 0,
                          ),
                        ),
                        gap(context, height: 20),
                        Padding(
                          padding: EdgeInsets.only(
                            top: sizing(15, context),
                            left: sizing(15, context),
                            right: sizing(15, context),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              $strings.shareTheApp,
                              maxLines: 1,
                              fontSize: 18,
                              color: $styles.colors.blue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(sizing(15, context)),
                          child: Container(
                            padding: EdgeInsets.all(sizing(10, context)),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(sizing(10, context)),
                              color: $styles.colors.white,
                              border: Border.all(
                                  color: $styles.colors.greyLight, width: 1),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      $appUtils.share();
                                    },
                                    icon: Icon(Icons.share,
                                        color: $styles.colors.blue)),
                                gap(context, width: 10),
                                Expanded(
                                  child: CustomInkWell(
                                      bgColor: $styles.colors.blue,
                                      onTap: () {
                                        $appUtils.shareToWhatsapp($appUtils
                                            .getSettings()
                                            ?.shareSnippet);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgImage(
                                              path: SvgPaths.icWhatsapp,
                                              color: $styles.colors.white,
                                            ),
                                            gap(context, width: 10),
                                            CustomText(
                                              "Whatsapp",
                                              color: $styles.colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                gap(context, width: 10),
                                Expanded(
                                  child: CustomInkWell(
                                      bgColor: $styles.colors.blue,
                                      onTap: () {
                                        $appUtils.copyToClipBoard(
                                            $appUtils
                                                .getSettings()
                                                ?.shareSnippet,
                                            context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.copy_rounded,
                                              color: $styles.colors.white,
                                            ),
                                            gap(context, width: 10),
                                            CustomText(
                                              "Copy",
                                              color: $styles.colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ));
  }

  void _getSettings() {
    bloc.getSettings(
        isShowLoading: false,
        uId: user.id?.toString(),
        pId: user.pid?.toString(),
        gId: user.gid?.toString(),
        callback: (p0) {
          if (p0.success == true && p0.data != null) {
            $appUtils.saveSettings(p0.data!);
            setState(() {
              unreadNotifications =
                  p0.data?.unreadNotificationsUser?.toInt() ?? 0;
            });
          }
        });
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var position = await Geolocator.getCurrentPosition();
    _onPlaceSelected(null, LatLng(position.latitude, position.longitude));
  }

  Future<String> _getAddressFromLatLng(latitude, longitude) async {
    try {
      List<Placemark>? placemarks = await GeocodingPlatform.instance
          ?.placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks![0];
      return "${place.locality}, ${place.administrativeArea}";
    } catch (e) {
      $logger.log(message: e.toString());
      return "";
    }
  }

  @override
  void observer() {
    super.observer();
    bloc.homeDtoStream.stream.listen((event) {
      setState(() {
        home = event.data ?? HomeResponseDto();
      });
    });
    bloc.profileStream.stream.listen((event) {
      if (event?.success == true && event?.data != null) {
        $user.saveDetails(event!.data!);
        $logger.log(message: "Blocked -------------> ${user.isBlocked}");
        if (user.isBlocked == true) {
          navigate(const Blocked(), finishAffinity: true);
        }
      }
    });
  }

  void _onPlaceSelected(Predictions? place, LatLng? latLng) {
    $logger.log(message: "message  ${place?.placeId}  $place  $latLng");
    if (place?.placeId != null && place != null) {
      disableDialogLoading = false;
      UserData newUser = user;
      newUser.address = place.description ?? "";
      newUser.latitude = place.latitude?.toDouble() ?? 0.0;
      newUser.longitude = place.longitude?.toDouble() ?? 0.0;
      $user.saveDetails(newUser);
      setState(() {
        address = place.description ?? "";
      });
      _updateLocation();
    } else {
      _getAddressFromLatLng(latLng?.latitude, latLng?.longitude).then((value) {
        UserData newUser = user;
        newUser.address = value;
        newUser.latitude = latLng?.latitude;
        newUser.longitude = latLng?.longitude;
        $user.saveDetails(newUser);
        setState(() {
          address = value;
        });
        _updateLocation();
      });
    }
  }

  _updateLocation() {
    UpdateUserRequestDto requestDto = UpdateUserRequestDto();
    requestDto.userId = user.id.toString();
    requestDto.latitude = user.latitude;
    requestDto.longitude = user.longitude;
    requestDto.address = user.address;
    AuthBloc().updateUser(
        request: requestDto,
        callback: (p0) {
          if (p0.success == true) {
            $user.saveDetails(p0.data!);
            setState(() {
              home = null;
              _getData();
            });
          }
        });
  }
}
