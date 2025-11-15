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

  FindPlaces({
    super.key,
    required this.onPlaceSelected,
    this.title,
    this.showCurrentLocationBtn = true,
    this.isCitiesOnly = false,
  });

  @override
  State<FindPlaces> createState() => _FindPlacesState();
}

class _FindPlacesState extends BaseState<FindPlaces, AuthBloc> {
  final TextEditingController _placeController = TextEditingController();
  List<Predictions> predictions = [];

  bool isSearching = false;

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
                  onPressed: () => navigatePop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: $styles.colors.title,
                  ),
                ),
                CustomText(
                  widget.title ?? "Pick Address For Better Results",
                  fontSize: titleSize(),
                  isBold: true,
                ),
              ],
            ),

            /// Search Input
            gap(context, height: 10),
            InputField(
              hint: $strings.searchPlaces,
              controller: _placeController,
              focusStrokeColor: $styles.colors.white,
              enabledStrokeColor: $styles.colors.white,
              bgColor: $styles.colors.white,
              disableLabel: true,
              iconStart:
                  Icon(Icons.search_rounded, color: $styles.colors.black),
            ),

            gap(context, height: 15),

            /// Current Location Button
            if (widget.showCurrentLocationBtn)
              DefaultButton(
                "Use Current Location",
                iconStart: Icon(
                  Icons.location_searching,
                  color: $styles.colors.white,
                  size: 15,
                ),
                onClick: () {
                  showLoading();
                  _determinePosition().then((value) {
                    dismissLoading();
                    if (!mounted) return;
                    navigatePop(context);
                    widget.onPlaceSelected(
                        null, LatLng(value.latitude, value.longitude));
                  });
                },
              ),
          ],
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizing(10, context),
          vertical: sizing(10, context),
        ),
        child: Column(
          children: [
            /// Loading Indicator
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
              },
            ),

            /// Places Result List
            Expanded(
              child: StreamBuilder<BaseListCallback<Predictions>?>(
                stream: bloc.placesResponseStream.stream,
                builder: (context, snapshot) {
                  final result = snapshot.data?.data;

                  /// No result found
                  if (snapshot.hasData &&
                      result != null &&
                      result.isEmpty &&
                      !isSearching) {
                    return Center(
                      child: CustomText("No Result"),
                    );
                  }

                  /// Show list when data comes
                  if (snapshot.hasData &&
                      result != null &&
                      result.isNotEmpty) {
                    predictions = result;

                    return ListView.builder(
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        final item = predictions[index];

                        return CustomInkWell(
                          bgColor: $styles.colors.white,
                          onTap: () {
                            widget.onPlaceSelected(
                              item,
                              LatLng(
                                item.latitude!.toDouble(),
                                item.longitude!.toDouble(),
                              ),
                            );
                            navigatePop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(sizing(15, context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  item.description ?? "",
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                gap(context, height: 5),
                                CustomText(
                                  "Lat: ${item.latitude}, Lng: ${item.longitude}",
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  /// Default message before search
                  return Center(
                    child: CustomText("Search"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Location Permission
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Search Listener
  @override
  void observer() {
    super.observer();

    _placeController.addListener(() {
      if (_placeController.text.isNotEmpty) {
        if (!isSearching) {
          isSearching = true;
          bloc.findPlaces(
            _placeController.text.toString(),
            widget.isCitiesOnly,
          );
          Future.delayed(Duration(milliseconds: 400), () {
            isSearching = false;
          });
        }
      }
    });
  }
}
