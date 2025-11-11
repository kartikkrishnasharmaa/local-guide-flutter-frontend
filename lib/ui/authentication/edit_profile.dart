import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/auth_bloc.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/utils/validator.dart';
import 'package:localguider/values/assets.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../maps/places_response.dart';
import '../../modals/find_places.dart';
import '../../models/requests/update_user_request_dto.dart';
import '../../responsive.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends BaseState<EditProfile, AuthBloc> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _nameError = "";
  String? _emailError = "";
  String? _addressError = "";

  File? profileImage;

  LatLng? latLng;
  String? address;

  var _nameValid = false;
  var _emailValid = false;

  @override
  void init() {
    _nameController.addListener(() {
      setState(() {
        _nameValid = _nameController.text.isNotEmpty;
      });
    });

    _emailController.addListener(() {
      setState(() {
        _emailValid = _emailController.text.isValidEmail();
      });
    });

    _nameController.text = user.name ?? "";
    _emailController.text = user.email ?? "";
    _addressController.text = user.address ?? "";
    latLng = LatLng(user.latitude?.toDouble() ?? 0.0, user.longitude?.toDouble() ?? 0.0);
    address = user.address;
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  Widget view() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
          onPressed: () {
            navigatePop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: $styles.colors.white,
          ),
        ),
        centerTitle: true,
        title: CustomText(
          "Account Details",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: AppImage(
                image: AssetImage(Images.kumbhalgarhFort),
                fit: BoxFit.fill,
              )),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: $styles.colors.realBlack.withOpacity(.8),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(sizing(15, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gap(context, height: 15),
                Center(
                  child: ProfileView(
                    diameter: 100, profileUrl: user.profile.appendRootUrl(), fileImage: profileImage,),
                ),
                gap(context, height: 20),
                Center(
                    child: CustomInkWell(
                      onTap: () {
                        pickImageDialog(
                                (bool success, String message, XFile? image) {
                              $logger.log(message: image != null ? image.path : "null");
                              if (success && image != null) {
                                setState(() {
                                  profileImage = File(image.path);
                                });
                              }
                            });
                      },
                      child: CustomText(
                        "Change Profile Photo",
                        fontSize: 14,
                        color: $styles.colors.white,
                        isBold: true,
                      ),
                    )),
                gap(context, height: 20),
                CustomText(
                  "Name",
                  color: $styles.colors.white,
                  fontSize: 12,
                  style: FontStyles.light,
                ),
                gap(context, height: 7),
                InputField(
                  hint: $strings.fullName,
                  disableLabel: true,
                  maxLength: 15,
                  padding: 8,
                  error: _nameError,
                  textColor: $styles.colors.white,
                  controller: _nameController,
                  iconEnd: _nameValid && _nameError.isNullOrEmpty()
                      ? Icon(Icons.check_circle, color: $styles.colors.blue)
                      : null,
                  validator: (text) {
                    if (text == null || text.isEmpty == true) {
                      return $strings.pleaseEnterFirstName;
                    } else if (text.length < 2) {
                      return $strings.pleaseEnterValidFirstName;
                    }
                    return null;
                  },
                ),
                gap(context, height: 20),
                CustomText(
                  "Email",
                  color: $styles.colors.white,
                  fontSize: 12,
                  style: FontStyles.light,
                ),
                gap(context, height: 7),
                InputField(
                  hint: $strings.email,
                  disableLabel: true,
                  maxLength: 50,
                  padding: 8,
                  error: _emailError,
                  textColor:  $styles.colors.white,
                  controller: _emailController,
                  iconEnd: _emailValid && _emailError.isNullOrEmpty()
                      ? Icon(Icons.check_circle, color: $styles.colors.blue)
                      : null,
                  validator: (text) {
                    if (text == null || text.isEmpty == true) {
                      return "Please enter email address";
                    } else if (!text.isValidEmail()) {
                      return "Please enter valid email address";
                    }
                    return null;
                  },
                ),
                gap(context, height: 20),
                CustomText(
                  "Address",
                  color: $styles.colors.white,
                  fontSize: 12,
                  style: FontStyles.light,
                ),
                gap(context, height: 7),
                InputField(
                  hint: $strings.address,
                  disableLabel: true,
                  maxLength: 15,
                  error: _addressError,
                  isDisable: true,
                  onClick: () {
                    navigate(FindPlaces(
                      onPlaceSelected: (Predictions? place, LatLng? mLatLng) {
                        if (place?.placeId != null && place != null) {
                          latLng = LatLng(
                            place.latitude?.toDouble() ?? 0.0,
                            place.longitude?.toDouble() ?? 0.0,
                          );
                          address = place.description ?? "";
                          _addressController.text = address ?? "";
                        } else {
                          _getAddressFromLatLng(
                              mLatLng?.latitude, mLatLng?.longitude)
                              .then((value) {
                            latLng = mLatLng;
                            address = value;
                            _addressController.text = value;
                          });
                        }
                      },
                    ));
                  },
                  onlyAlphabet: true,
                  textColor: $styles.colors.white,
                  controller: _addressController,
                  iconEnd: latLng != null
                      ? Icon(Icons.check_circle, color: $styles.colors.blue)
                      : null,
                  validator: (text) {
                    if (text == null || text.isEmpty == true) {
                      return $strings.addressIsRequired;
                    }
                    return null;
                  },
                ),
                gap(context, height: 25),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: DefaultButton("Save", onClick: () {
                      if(_nameController.text.toString().isNullOrEmpty()) {
                        setState(() {
                          _nameError = "Please enter name.";
                        });
                      }
                      if(_emailController.text.toString().isNullOrEmpty()) {
                        setState(() {
                          _emailError = "Please enter email.";
                        });
                      }
                      if(_addressController.text.toString().isNullOrEmpty()) {
                        setState(() {
                          _addressError = "Address cannot be empty.";
                        });
                      }
                      _updateProfile();
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _updateProfile() async {
    UpdateUserRequestDto requestDto = UpdateUserRequestDto();
    requestDto.userId = user.id.toString();
    requestDto.name = _nameController.text;
    requestDto.email = _emailController.text;
    requestDto.address = _addressController.text;
    requestDto.latitude = latLng?.latitude;
    requestDto.longitude = latLng?.longitude;
    if(profileImage != null) {
      requestDto.profile = await convertFileToMultipart(profileImage!);
    }
    bloc.updateUser(request: requestDto, callback: (p0) {
      if(p0.success == true) {
        $user.saveDetails(p0.data!);
        snackBar("Success!", "Profile updated successfully.");
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  static Future<MultipartFile> convertFileToMultipart(File file) async {
    // Compress the image
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 20, // Set the quality of compression (0 to 100)
    );

    List<int>? compressedByteList = compressedBytes?.toList();
    if (compressedByteList == null) {
      return MultipartFile.fromFileSync(file.path);
    }
    File compressedImage = File('${file.path}_compressed.jpg');
    await compressedImage.writeAsBytes(compressedByteList);

    return MultipartFile.fromFile(
      compressedImage.path,
    );
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
}
