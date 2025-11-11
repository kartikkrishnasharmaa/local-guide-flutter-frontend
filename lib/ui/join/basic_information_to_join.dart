import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/modals/find_places.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/search/search_content.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/ui/services/services_list.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/utils/validator.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../maps/places_response.dart';
import '../../models/response/service_dto.dart';

class BasicInformationToJoin extends StatefulWidget {
  GlobalKey<FormState>? formKey;

  UserRole userRole;
  PhotographerDto? dto;

  Function(
      Uint8List? featuredImage,
      String firmName,
      String email,
      String phone,
      String address,
      String description,
      List<ServiceDto> services,
      List<PlaceModel> places)? onInfoUpdate;

  BasicInformationToJoin(
      {super.key,
      required this.formKey,
      required this.userRole,
      required this.onInfoUpdate,
      this.dto});

  @override
  State<BasicInformationToJoin> createState() => _BasicInformationToJoinState();
}

class _BasicInformationToJoinState
    extends BaseState<BasicInformationToJoin, HomeBloc> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<ServiceDto> _services = [];
  List<PlaceModel> _places = [];

  Uint8List? featuredImage;

  bool isEdit = false;

  @override
  void init() {
    isEdit = widget.dto != null;
    disableDialogLoading = true;
    _setListeners();
    if (widget.dto != null) {
      _nameController.text = widget.dto?.firmName ?? "";
      _emailController.text = widget.dto?.email ?? "";
      _phoneController.text = widget.dto?.phone ?? "";
      _addressController.text = widget.dto?.address ?? "";
      _descriptionController.text = widget.dto?.description ?? "";
    }
    bloc.getServices(
        widget.userRole == UserRole.PHOTOGRAPHER
            ? widget.dto?.id.toString()
            : null,
        widget.userRole == UserRole.GUIDER ? widget.dto?.id.toString() : null,
        (response) {
      if (response.success == true) {
        _services = response.data ?? [];
        _syncInfo();
      }
    });
    bloc.getPlacesByIds(widget.dto?.places ?? "", (response) {
      if (response.success == true) {
        _places = response.data ?? [];
        _syncInfo();
        setState(() {});
      }
    });
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: $styles.colors.blueBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(sizing(15, context)),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                gap(context, height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomText(
                    "Basic Information",
                    fontSize: sizing(17, context),
                    style: FontStyles.openSansBold,
                  ),
                ),
                gap(context, height: 20),
                InkWell(
                  onTap: () {
                    pickImageDialog(
                      (bool success, String message, XFile? image) async {
                        $logger.log(
                            message: image != null ? image.path : "null");
                        if (success && image != null) {
                          featuredImage = await image.readAsBytes();
                          _syncInfo();
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
                        borderRadius:
                            BorderRadius.circular(sizing(15, context))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(sizing(15, context)),
                      child: featuredImage != null
                          ? Image.memory(
                              featuredImage!,
                              fit: BoxFit.cover,
                            )
                          : widget.dto?.featuredImage != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      widget.dto!.featuredImage.appendRootUrl())
                              : Center(
                                  child: Icon(
                                  Icons.add,
                                  size: sizing(30, context),
                                  color: $styles.colors.black,
                                )),
                    ),
                  ),
                ),
                gap(context, height: 7),
                Center(
                    child: CustomText(
                  "Select Featured Image",
                  fontSize: sizing(12, context),
                )),
                gap(context, height: 20),
                InputField(
                    hint: "Firm/Company/Person Name",
                    radius: 30,
                    disableLabel: true,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter firm name";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _nameController),
                gap(context, height: 20),
                InputField(
                    hint: "Email",
                    radius: 30,
                    disableLabel: true,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter email";
                      } else if (!text.isValidEmail()) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _emailController),
                gap(context, height: 20),
                InputField(
                    hint: "Phone number",
                    radius: 30,
                    maxLength: 10,
                    isNumeric: true,
                    disableLabel: true,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter phone number";
                      } else if (!text.isValidPhoneNumber()) {
                        return "Please enter valid phone number";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _phoneController),
                gap(context, height: 20),
                InputField(
                    hint: "Your Address",
                    radius: 30,
                    disableLabel: true,
                    iconEnd:
                        Icon(Icons.map_rounded, color: $styles.colors.blue),
                    onIconEndTap: (text) {
                      _addressSelection();
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please select your address";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _addressController),
                gap(context, height: 20),
                Container(
                  padding: EdgeInsets.all(sizing(15, context)),
                  decoration: BoxDecoration(
                    color: $styles.colors.greyLight,
                    border: Border.all(color: $styles.colors.borderColor()),
                    borderRadius: BorderRadius.circular(sizing(30, context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          child: Row(
                            children: [
                              CustomText(
                                  "Select Place (Where you provide service)",
                                  fontSize: sizing(14, context)),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: $styles.colors.black,
                                size: sizing(15, context),
                              )
                            ],
                          ),
                          onTap: () {
                            navigate(SearchContent(
                              searchType: SearchTypes.placePick,
                              multiSelection: true,
                              maxSelection: 3,
                              selectedPlaces: _places,
                              onPlacesSelected: (places) {
                                setState(() {
                                  _places = places;
                                  _syncInfo();
                                });
                              },
                            ));
                          }),
                      if (_places.isNotEmpty) gap(context, height: 10),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return CustomText(
                            " ${index + 1}. ${_places[index].placeName}",
                            maxLines: 1,
                          );
                        },
                        itemCount: _places.length,
                        shrinkWrap: true,
                      )
                    ],
                  ),
                ),
                if (!isEdit) gap(context, height: 20),
                if (!isEdit)
                  Container(
                    padding: EdgeInsets.all(sizing(15, context)),
                    decoration: BoxDecoration(
                      color: $styles.colors.greyLight,
                      border: Border.all(color: $styles.colors.borderColor()),
                      borderRadius: BorderRadius.circular(sizing(30, context)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            child: Row(
                              children: [
                                CustomText("Add Services",
                                    fontSize: sizing(14, context)),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: $styles.colors.black,
                                  size: sizing(15, context),
                                )
                              ],
                            ),
                            onTap: () {
                              navigate(ServicesList(
                                selectedService: _services,
                                isSelectionOnly: true,
                                callback: (services) {
                                  setState(() {
                                    _services = services;
                                    _syncInfo();
                                  });
                                },
                              ));
                            }),
                        if (_services.isNotEmpty) gap(context, height: 10),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return CustomText(
                              " ${index + 1}. ${_services[index].title}",
                              maxLines: 1,
                            );
                          },
                          itemCount: _services.length,
                          shrinkWrap: true,
                        )
                      ],
                    ),
                  ),
                gap(context, height: 20),
                InputField(
                    hint: "Write about your services/firm",
                    radius: 30,
                    disableLabel: true,
                    maxLines: 10,
                    minLines: 5,
                    maxLength: 5000,
                    inputType: TextInputType.multiline,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                    bgColor: $styles.colors.white,
                    controller: _descriptionController),
                gap(context, height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _getAddressFromLatLng(latitude, longitude) async {
    try {
      List<Placemark>? placemarks = await GeocodingPlatform.instance
          ?.placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks![0];
      return "${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
    } catch (e) {
      $logger.log(message: e.toString());
      return "";
    }
  }

  _setListeners() {
    _nameController.addListener(() {
      _syncInfo();
    });
    _emailController.addListener(() {
      _syncInfo();
    });
    _phoneController.addListener(() {
      _syncInfo();
    });
    _addressController.addListener(() {
      _syncInfo();
    });
    _descriptionController.addListener(() {
      _syncInfo();
    });
  }

  _syncInfo() {
    if(widget.onInfoUpdate == null) return;
    widget.onInfoUpdate!(
        featuredImage,
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _addressController.text,
        _descriptionController.text,
        _services,
        _places);
  }

  void _addressSelection() {
    navigate(FindPlaces(
        title: "Pick your address",
        onPlaceSelected: (Predictions? place, LatLng? latLng) {
          $logger.log(message: "message  ${place?.placeId}  $place  $latLng");
          if (place?.placeId != null && place != null) {
            disableDialogLoading = false;
            _addressController.text = place.description ?? "";
          } else {
            _getAddressFromLatLng(latLng?.latitude, latLng?.longitude)
                .then((value) {
              _addressController.text = value;
            });
          }
        }));
  }
}
