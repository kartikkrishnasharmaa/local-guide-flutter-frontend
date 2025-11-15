import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/modals/find_places.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/ui/admin/places/place_details_admin.dart';
import 'package:localguider/utils/extensions.dart';
import '../../../base/base_callback.dart';
import '../../../common_libs.dart';
import '../../../components/custom_text.dart';
import '../../../main.dart';
import '../../../maps/places_response.dart';
import '../../../modals/items_selection.dart';
import '../../../models/selection_model.dart';
import '../../../responsive.dart';

class AddEditPlace extends StatefulWidget {
  final PlaceModel? placeModel;
  final Function(PlaceModel) refreshCallback;

  const AddEditPlace({
    super.key,
    this.placeModel,
    required this.refreshCallback,
  });

  @override
  State<AddEditPlace> createState() => _AddEditPlaceState();
}

class _AddEditPlaceState extends BaseState<AddEditPlace, HomeBloc> {
  var isEdit = false;

  Uint8List? featuredImageBytes;
  bool isTopPlace = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final _statesList = <SelectionModel>[];
  SelectionModel? _state;
  LatLng? latLng;
  String? _mapUrl;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void init() async {
    isEdit = widget.placeModel != null;
    _addAllStates();

    if (isEdit) {
      _nameController.text = widget.placeModel?.placeName ?? "";
      _descriptionController.text = widget.placeModel?.description ?? "";
      _state = _statesList.firstWhere(
        (element) => element.title == widget.placeModel?.state,
        orElse: () => SelectionModel(title: widget.placeModel?.state ?? ""),
      );
      _stateController.text = widget.placeModel?.state ?? "";
      _cityController.text = widget.placeModel?.city ?? "";
      _locationController.text = widget.placeModel?.fullAddress ?? "";
      _mapUrl = widget.placeModel?.mapUrl;
      isTopPlace = widget.placeModel?.isTop ?? false;

      latLng = LatLng(
        widget.placeModel!.latitude!.toDouble(),
        widget.placeModel!.longitude!.toDouble(),
      );
    }
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    _stateController.text = (_state != null ? _state?.title! : "")!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
          onPressed: () => navigatePop(context),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: $styles.colors.white),
        ),
        centerTitle: true,
        title: CustomText(
          isEdit ? "Edit Place" : "Add Place",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
        actions: [
          IconButton(
            onPressed: _save,
            icon: Icon(Icons.check, color: $styles.colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sizing(15, context)),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  pickImageDialog(
                    useCamera: false,
                    (bool success, String message, XFile? image) async {
                      if (success && image != null) {
                        featuredImageBytes = await image.readAsBytes();
                        setState(() {});
                      }
                    },
                  );
                },
                child: Container(
                  height: sizing(170, context),
                  width: sizing(200, context),
                  decoration: BoxDecoration(
                    color: $styles.colors.greyLight,
                    border: Border.all(color: $styles.colors.greyLight),
                    borderRadius: BorderRadius.circular(sizing(15, context)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sizing(15, context)),
                    child: featuredImageBytes != null
                        ? Image.memory(featuredImageBytes!, fit: BoxFit.cover)
                        : isEdit && widget.placeModel?.featuredImage != null
                            ? AppImage(
                                image: NetworkImage(widget
                                    .placeModel!.featuredImage
                                    .appendRootUrl()),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Icon(
                                  Icons.add,
                                  size: sizing(30, context),
                                  color: $styles.colors.black,
                                ),
                              ),
                  ),
                ),
              ),
              gap(context, height: 7),
              Center(
                child: CustomText(
                  "Select Featured Image",
                  fontSize: sizing(12, context),
                ),
              ),
              gap(context, height: 15),

              /// PLACE NAME
              InputField(
                hint: "Place name",
                validator: (text) {
                  if (text.isNullOrEmpty() == true) {
                    return "Please enter name";
                  }
                  return null;
                },
                controller: _nameController,
              ),
              gap(context, height: 10),

              /// STATE
              InputField(
                hint: "State",
                validator: (text) {
                  if (text.isNullOrEmpty() == true) {
                    return "Please select state of the place.";
                  }
                  return null;
                },
                onClick: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 1,
                        child: ItemSelectionSheet(
                          title: "Select State",
                          selectedItem: _state,
                          onItemSelected: (newState) {
                            setState(() {
                              _state = newState;
                            });
                          },
                          list: _statesList,
                        ),
                      );
                    },
                  );
                },
                isDisable: true,
                controller: _stateController,
              ),
              gap(context, height: 10),

              /// CITY — FIXED LAT/LNG SET HERE
              InputField(
                hint: "City",
                isDisable: true,
                onClick: () {
                  navigate(
                    FindPlaces(
                      onPlaceSelected:
                          (Predictions? place, LatLng? locationLatLng) {
                        setState(() {
                          _cityController.text = place?.description ?? "";
                          latLng = locationLatLng; // FIXED
                          _mapUrl = place?.mapUrl;
                        });
                      },
                      title: "Pick the city of place",
                      showCurrentLocationBtn: true,
                      isCitiesOnly: true,
                    ),
                  );
                },
                validator: (text) {
                  if (text.isNullOrEmpty() == true) {
                    return "This field is required.";
                  }
                  return null;
                },
                controller: _cityController,
              ),
              gap(context, height: 10),

              /// ADDRESS - ALSO SETS LAT/LNG
              InputField(
                hint: "Address/Locality",
                isDisable: false,
                onClick: () {
                  navigate(
                    FindPlaces(
                      onPlaceSelected:
                          (Predictions? place, LatLng? locationLatLng) {
                        setState(() {
                          latLng = locationLatLng;
                          _mapUrl = place?.mapUrl;
                          _locationController.text = place?.description ?? "";
                        });
                      },
                      title: "Pick the address of place",
                      showCurrentLocationBtn: false,
                    ),
                  );
                },
                validator: (text) {
                  if (text.isNullOrEmpty() == true) {
                    return "This field is required.";
                  }
                  return null;
                },
                controller: _locationController,
              ),
              gap(context, height: 10),

              /// TOP PLACE SWITCH
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    CupertinoSwitch(
                        value: isTopPlace, onChanged: onChanged),
                    gap(context, width: 10),
                    CustomText("Top Place"),
                  ],
                ),
              ),
              gap(context, height: 10),

              /// DESCRIPTION
              InputField(
                hint: "Description",
                minLines: 15,
                maxLines: 100,
                maxLength: 5000,
                inputType: TextInputType.multiline,
                validator: (text) {
                  if (text.isNullOrEmpty() == true) {
                    return "Please enter about this place.";
                  }
                  return null;
                },
                controller: _descriptionController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ADD STATES
  void _addAllStates() {
    _statesList.addAll([
      "Andhra Pradesh",
      "Arunachal Pradesh",
      "Assam",
      "Bihar",
      "Chhattisgarh",
      "Goa",
      "Gujarat",
      "Haryana",
      "Himachal Pradesh",
      "Jharkhand",
      "Karnataka",
      "Kerala",
      "Madhya Pradesh",
      "Maharashtra",
      "Manipur",
      "Meghalaya",
      "Mizoram",
      "Nagaland",
      "Odisha",
      "Punjab",
      "Rajasthan",
      "Sikkim",
      "Tamil Nadu",
      "Telangana",
      "Tripura",
      "Uttar Pradesh",
      "Uttarakhand",
      "West Bengal",
    ].map((e) => SelectionModel(title: e)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (latLng == null) {
        snackBar("Failed!", "Please select city/address properly.");
        return;
      }

      if (featuredImageBytes == null && !isEdit) {
        snackBar($strings.failed, "Please select featured image.");
        return;
      }

      if (isEdit) {
        bloc.updatePlace(
          placeId: widget.placeModel?.id.toString(),
          placeName: _nameController.text,
          description: _descriptionController.text,
          featuredImage: featuredImageBytes,
          city: _cityController.text.toString(),
          address: _locationController.text.toString(),
          mapUrl: _mapUrl,
          topPlace: isTopPlace,
          state: _stateController.text,
          lat: latLng?.latitude,
          lng: latLng?.longitude,
          callback: (p0) => _handleResponse(p0),
        );
      } else {
        bloc.addPlace(
          placeName: _nameController.text,
          description: _descriptionController.text,
          featuredImage: featuredImageBytes,
          state: _stateController.text,
          city: _cityController.text.toString(),
          address: _locationController.text.toString(),
          topPlace: isTopPlace,
          mapUrl: _mapUrl,
          lat: latLng?.latitude,
          lng: latLng?.longitude,
          callback: (p0) => _handleResponse(p0),
        );
      }
    }
  }

  void onChanged(bool? value) {
    setState(() {
      isTopPlace = value!;
    });
  }

  void _handleResponse(BaseCallback<PlaceModel> callback) {
    if (callback.success == true) {
      snackBar("Success!",
          isEdit ? "Place updated successfully." : "Place Added Successfully.");

      widget.refreshCallback(callback.data!);

      if (isEdit) {
        navigatePop(context);
      } else {
        navigate(
          PlaceDetailsAdmin(
            placeModel: callback.data!,
            refreshCallback: () {},
          ),
          finish: true,
        );
      }
    } else {
      snackBar("Failed!", callback.message ?? $strings.SOME_THING_WENT_WRONG);
    }
  }
}
