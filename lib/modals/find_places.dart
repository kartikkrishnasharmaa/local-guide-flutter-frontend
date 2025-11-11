import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localguider/base/base_callback.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/auth_bloc.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/input_field.dart';

import '../common_libs.dart';
import '../components/custom_text.dart';
import '../main.dart';
import '../maps/places_response.dart';
import '../responsive.dart';

class FindPlaces extends StatefulWidget {

  String? title;
  bool showCurrentLocationBtn = true;
  bool isCitiesOnly = false;
  Function(Predictions? place, LatLng? latLng) onPlaceSelected;
  FindPlaces({super.key, required this.onPlaceSelected, this.title, this.showCurrentLocationBtn = true, this.isCitiesOnly = false});

  @override
  State<FindPlaces> createState() => _FindPlacesState();
}

class _FindPlacesState extends BaseState<FindPlaces, AuthBloc> {
  List<Predictions> predictions = [];
  final TextEditingController _placeController = TextEditingController();
  var isSearching = false;

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.secondarySurface,
      appBar: AppBar(
        backgroundColor: $styles.colors.secondarySurface,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: $styles.colors.secondarySurface,
        titleSpacing: 10,
        toolbarHeight: 185,
        title: Column(
          children: [
           Row(
              children: [
                IconButton(
                  onPressed: () {
                    navigatePop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: $styles.colors.title),
                ),
                CustomText(
                  widget.title ?? "Pick Address For Better Results",
                  fontSize: titleSize(),
                  isBold: true,
                )
              ],
            ),
            gap(context, height: 10),
            InputField(
              hint: $strings.searchPlaces,
              controller: _placeController,
              focusStrokeColor: $styles.colors.white,
              enabledStrokeColor: $styles.colors.white,
              bgColor: $styles.colors.white,
              iconStart:
                  Icon(Icons.search_rounded, color: $styles.colors.black),
              disableLabel: true,
            ),
            gap(context, height: 15),
            if(widget.showCurrentLocationBtn) DefaultButton("Use Current Location",
                iconStart: Icon(
                  Icons.location_searching,
                  color: $styles.colors.white,
                  size: 15,
                ), onClick: () {
              showLoading();
              _determinePosition().then((value) {
                dismissLoading();
                if(!mounted) return;
                navigatePop(context);
                widget.onPlaceSelected(
                    null, LatLng(value.latitude, value.longitude));
              });
            })
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: $styles.colors.secondarySurface,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(sizing(10, context)),
                topLeft: Radius.circular(sizing(10, context))),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: sizing(10, context),
            right: sizing(10, context),
            top: sizing(10, context),
          ),
          child: Column(
            children: [
              StreamBuilder(
                  stream: bloc.loadingController.stream,
                  builder: (context, snapshot) {
                    return (snapshot.data ?? false)
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(sizing(20, context)),
                              child: CircularProgressIndicator(
                                color: $styles.colors.blue,
                              ),
                            ),
                          )
                        : Container();
                  }),
              StreamBuilder<BaseListCallback<Predictions>?>(
                  stream: bloc.placesResponseStream.stream,
                  builder: (context, snapshot) {
                    var result = snapshot.data?.data;
                    var isDefault = true;
                    var isEmpty = false;
                    isSearching = false;
                    if (snapshot.hasData &&
                        result != null &&
                        result.isNotEmpty) {
                      predictions.clear();
                      predictions = snapshot.data?.data ?? [];
                      isEmpty = false;
                      isDefault = false;
                    } else if (snapshot.hasData &&
                        result != null &&
                        result.isEmpty) {
                      predictions = [];
                      isEmpty = true;
                      isDefault = false;
                    }
                    return isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(sizing(50, context)),
                            child: CustomText("No Result"),
                          )
                        : (isDefault
                            ? Padding(
                                padding: EdgeInsets.all(sizing(50, context)),
                                child: CustomText("Search"),
                              )
                            : SizedBox(
                                height: 300,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: predictions.length,
                                    itemBuilder: (context, index) {
                                      return predictions
                                          .map((e) => CustomInkWell(
                                              bgColor: $styles.colors.white,
                                              onTap: () {
                                                widget.onPlaceSelected(
                                                    predictions[index], null);
                                                navigatePop(context);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    sizing(15, context)),
                                                child: CustomText(
                                                    e.description ?? ""),
                                              )))
                                          .toList()[index];
                                    }),
                              ));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
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
    return await Geolocator.getCurrentPosition();
  }

  @override
  void observer() {
    super.observer();
    _placeController.addListener(() {
      if (_placeController.text.isNotEmpty) {
        if (!isSearching) {
          isSearching = true;
          $logger.log(message: "message>>>>> Search Text  ${_placeController.text.toString()}");
          bloc.findPlaces(_placeController.text.toString(), widget.isCitiesOnly);
        }
      }
    });
  }
}
