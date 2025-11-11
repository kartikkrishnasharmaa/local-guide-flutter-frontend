import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localguider/modals/find_places.dart';
import 'package:localguider/modals/reason_of_block.dart';
import 'package:localguider/models/requests/update_user_request_dto.dart';
import 'package:localguider/ui/dashboard/appointment_requests.dart';
import 'package:localguider/ui/dashboard/appointment_requests_main_page.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/ui/payments/transactions.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';
import '../../base/base_state.dart';
import '../../blocs/auth_bloc.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../components/date_picker.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../components/profile_view.dart';
import '../../main.dart';
import '../../maps/places_response.dart';
import '../../modals/items_selection.dart';
import '../../models/response/user_data.dart';
import '../../models/selection_model.dart';
import '../../responsive.dart';
import '../../utils/time_utils.dart';

class UserInformation extends StatefulWidget {
  String phone;
  String password;
  UserData? userData;
  bool isAdmin = false;
  bool isEditProfile = false;

  Function(UserData userData)? onUpdate;

  UserInformation(
      {super.key,
      required this.phone,
      required this.password,
      this.userData,
      this.onUpdate,
      this.isAdmin = false, this.isEditProfile = false});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends BaseState<UserInformation, AuthBloc> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobNoController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  LatLng? latLng;
  String? address;

  Uint8List? profileImage;

  final String _usernameError = "";
  final String _nameError = "";
  final _addressError = "";
  final String _dobError = "";
  final String _genderError = "";

  var _isUsernameValid = false;
  var _nameValid = false;

  var genderList = <SelectionModel>[];
  SelectionModel? _gender;

  DateTime? dob;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEdit = false;

  @override
  void init() {
    $logger.log(message: widget.userData?.toJson().toString() ?? "");

    disableDialogLoading = true;
    genderList.add(
        SelectionModel(title: $strings.male, selected: true, icon: Icons.male));
    genderList.add(SelectionModel(
        title: $strings.female, selected: false, icon: Icons.female));

    if (widget.userData != null) {
      isEdit = true;

      if (widget.userData?.dob != null) {
        dob =
            TimeUtils.parse(widget.userData?.dob, format: TimeUtils.yyyyMMdd);
      }

      try {
        if (widget.userData?.gender != null) {
          _gender = genderList.firstWhere((element) =>
              element.title?.trim().toLowerCase() ==
              widget.userData?.gender?.trim().toLowerCase());
        }

        latLng = LatLng(widget.userData!.latitude!.toDouble(),
            widget.userData!.longitude!.toDouble());
      } catch (e) {
        $logger.printObj(e);
      }

      _nameController.text = widget.userData?.name ?? "";
      _usernameController.text = widget.userData?.username ?? "";
      _addressController.text = widget.userData?.address ?? "";

      _genderController.text = widget.userData?.gender ?? "";
    } else {
      _nameController.text = user.name ?? "";
    }

    $logger.log(
        message: "message>>>>>>>>>>>>>>>>>>  ${widget.userData?.gender}");
  }

  @override
  Widget view() {
    _genderController.text = (_gender != null ? _gender?.title! : "")!;
    _dobNoController.text =
        dob != null ? TimeUtils.format(dob, format: TimeUtils.ddMMMyyyy) : "";

    _setListeners();

    return Scaffold(
      backgroundColor: $styles.colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: $styles.colors.white,
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigatePop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: $styles.colors.title),
        ),
        title: CustomText(
          isEdit ? _nameController.text : $strings.basicDetails,
          fontSize: sizing(16, context),
          color: $styles.colors.black,
        ),
      ),
      body: Stack(
        children: [
          gap(context, height: 20),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: sizing(100, context),
            child: Padding(
              padding: EdgeInsets.all(sizing(10, context)),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Center(
                        child: ProfileView(
                          diameter: 100, profileUrl: user.profile.appendRootUrl(), uintList: profileImage,),
                      ),
                      gap(context, height: 10),
                      Center(
                          child: CustomInkWell(
                            onTap: () {
                              pickImageDialog(
                                      (bool success, String message, XFile? image) async {
                                    $logger.log(message: image != null ? image.path : "null");
                                    if (success && image != null)  {
                                      profileImage = await image.readAsBytes();
                                      setState(() { });
                                    }
                                  });
                            },
                            child: CustomText(
                              "Change Profile Photo",
                              fontSize: 14,
                              color: $styles.colors.blue,
                              isBold: true,
                            ),
                          )),
                      gap(context, height: 20),
                      InputField(
                        hint: $strings.username,
                        disableLabel: true,
                        error: _usernameError,
                        isUsername: true,
                        maxLength: 30,
                        textColor: _isUsernameValid ? $styles.colors.blue : null,
                        controller: _usernameController,
                        iconEnd: _isUsernameValid
                            ? Icon(Icons.check_circle, color: $styles.colors.blue)
                            : null,
                        validator: (text) {
                          if (text == null || text.isEmpty == true) {
                            return $strings.pleaseEnterUsername;
                          } else if (text.length < 3) {
                            return $strings.pleaseEnterValidUsername;
                          } else if (text.isNumberOnly()) {
                            return $strings.onlyNumericNotAllowed;
                          }
                          return null;
                        },
                      ),
                      gap(context, height: 10),
                      if (widget.isAdmin || widget.isEditProfile)
                        InputField(
                          hint: $strings.phoneNumber,
                          disableLabel: true,
                          isNumeric: true,
                          isDisable: true,
                          textColor: _isUsernameValid ? $styles.colors.blue : null,
                          controller:
                              TextEditingController(text: widget.userData?.phone),
                          iconEnd: widget.userData?.phone != null
                              ? Icon(Icons.check_circle, color: $styles.colors.blue)
                              : null,
                        ),
                      gap(context, height: 10),
                      InputField(
                        hint: $strings.fullName,
                        disableLabel: true,
                        maxLength: 30,
                        error: _nameError,
                        textColor: _nameValid && _nameError.isNullOrEmpty()
                            ? $styles.colors.blue
                            : null,
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
                      gap(context, height: 10),
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
                                latLng = LatLng(place.latitude?.toDouble() ?? 0.0,
                                    place.longitude?.toDouble() ?? 0.0);
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
                        textColor: latLng != null ? $styles.colors.blue : null,
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
                      gap(context, height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              hint: $strings.birthday,
                              isDisable: true,
                              disableLabel: true,
                              error: _dobError,
                              onClick: () {
                                appDatePicker(
                                    context: context,
                                    initialDateTime: dob,
                                    title: $strings.selectDate,
                                    onPick: (pickedDate) {
                                      if (pickedDate != null) {
                                        setState(() {
                                          dob = pickedDate;
                                        });
                                      }
                                    });
                              },
                              textColor: dob != null && _dobError.isNullOrEmpty()
                                  ? $styles.colors.blue
                                  : null,
                              controller: _dobNoController,
                              iconEnd: dob != null && _dobError.isNullOrEmpty()
                                  ? Icon(Icons.check_circle,
                                      color: $styles.colors.blue)
                                  : null,
                              validator: (text) {
                                if (text == null || text.isEmpty == true) {
                                  return $strings.pleaseEnterDob;
                                }
                                return null;
                              },
                            ),
                          ),
                          gap(context, width: 10),
                          Expanded(
                            child: InputField(
                              hint: $strings.gender,
                              disableLabel: true,
                              error: _genderError,
                              isDisable: true,
                              onClick: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.5,
                                        child: ItemSelectionSheet(
                                          title: $strings.selectGender,
                                          selectedItem: _gender,
                                          onItemSelected: (gender) {
                                            _onGenderChange(gender);
                                          },
                                          list: genderList,
                                        ),
                                      );
                                    });
                              },
                              textColor:
                                  _gender != null && _genderError.isNullOrEmpty()
                                      ? $styles.colors.blue
                                      : null,
                              controller: _genderController,
                              iconEnd:
                                  _gender != null && _genderError.isNullOrEmpty()
                                      ? Icon(Icons.check_circle,
                                          color: $styles.colors.blue)
                                      : null,
                              validator: (text) {
                                if (text == null || text.isEmpty == true) {
                                  return $strings.pleaseSelectGender;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      gap(context, height: 20),
                      if (widget.isAdmin) _adminActionBtn()
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: sizing(15, context),
                      right: sizing(15, context),
                      top: sizing(15, context),
                      bottom: sizing(40, context)),
                  decoration: BoxDecoration(
                      color: $styles.colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sizing(20, context)),
                        topRight: Radius.circular(sizing(20, context)),
                      )),
                  child: DefaultButton(isEdit ? "Save" : $strings.next,
                      textColor: $styles.colors.black,
                      loadingController: bloc.loadingController,
                      bgColor: $styles.colors.white, onClick: () {
                    if (isEdit) {
                      _update();
                    } else {
                      _register();
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminActionBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText("Actions"),
        gap(context, height: 10),
        Row(
          children: [
            DefaultButton("View Transactions", onClick: () {
              navigate(Transactions(
                userRole: UserRole.JUST_USER,
                dtoId: widget.userData?.id.toString(),
              ));
            }),
            gap(context, width: 10),
            DefaultButton("View Appointments", onClick: () {
              navigate(AppointmentRequestsMainPage(
                role: UserRole.JUST_USER,
                dtoId: widget.userData?.id.toString(),
                initialStatus: AppointmentStatus.requested,
              ));
            }),
            gap(context, width: 10),
            DefaultButton(
                widget.userData?.isBlocked == true ? "Unblock" : "Block",
                bgColor: widget.userData?.isBlocked == true
                    ? $styles.colors.green
                    : $styles.colors.red, onClick: () {
              if (widget.userData?.isBlocked == true) {
                _blockUser();
              } else {
                _reasonOfBlockDialog();
              }
            }),
          ],
        ),
      ],
    );
  }

  void _register() {
    // RegisterRequestDto requestDto = RegisterRequestDto();
    // requestDto.phone = widget.phone.isNotEmpty ? widget.phone : "";
    // requestDto.name = _nameController.text;
    // requestDto.username = _usernameController.text;
    // requestDto.countryCode = "+91";
    // requestDto.gender = _gender?.title.toString();
    // requestDto.address = _addressController.text;
    // requestDto.latitude = latLng?.latitude;
    // requestDto.longitude = latLng?.longitude;
    // requestDto.password = widget.password;
    // requestDto.dateOfBirth = TimeUtils.format(dob);
    // bloc.register(request: requestDto);
  }

  void _update() async {
    UpdateUserRequestDto requestDto = UpdateUserRequestDto();
    requestDto.userId = widget.userData?.id.toString();
    requestDto.name = _nameController.text;
    requestDto.username = _usernameController.text;
    requestDto.countryCode = "+91";
    requestDto.address = _addressController.text;
    requestDto.gender = _gender?.title.toString();
    requestDto.latitude = latLng?.latitude;
    requestDto.longitude = latLng?.longitude;
    requestDto.password = widget.password;
    if (_gender != null) {
      requestDto.gender = _gender?.title;
    }
    if(profileImage != null) {
      requestDto.profile = await convertListToMultipart(profileImage!);
    }
    requestDto.dateOfBirth = TimeUtils.format(dob);
    $logger.log(message: "message>>>>>>>>>>>>>>>>>>  ${requestDto.toJson()}");
    disableDialogLoading = false;
    bloc.updateUser(
        request: requestDto,
        callback: (p0) {
          disableDialogLoading = true;
          if (p0.success == true) {
            snackBar("Success", "User updated successfully.");
            widget.onUpdate!(p0.data!);
            navigatePop(context);
          } else {
            snackBar("Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
          }
        });
  }

  static Future<MultipartFile> convertListToMultipart(Uint8List file) async {
    // Compress the image
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
      file,
      quality: 20, // Set the quality of compression (0 to 100)
    );
    List<int>? compressedByteList = compressedBytes.toList();
    return MultipartFile.fromBytes(
      compressedByteList,
      filename: $user.getUser()?.name
    );
  }

  _setListeners() {
    _usernameController.addListener(() {
      setState(() {
        _isUsernameValid = _usernameController.text.isNotEmpty &&
            _usernameController.text.length >= 3;
      });
    });

    _nameController.addListener(() {
      setState(() {
        _nameValid = _nameController.text.isNotEmpty;
      });
    });
  }

  void _reasonOfBlockDialog() {
    Get.dialog(
        barrierDismissible: false,
        Dialog(
            backgroundColor: $styles.colors.white,
            child: ReasonOfBlock(onDone: (text) {
              _blockUser(reasonOfBlock: text);
            })));
  }

  void _blockUser({String? reasonOfBlock}) {
    disableDialogLoading = false;
    bloc.updateUser(
        request: UpdateUserRequestDto(
            userId: widget.userData?.id.toString(),
            isBlocked: !(widget.userData?.isBlocked ?? false),
            reasonOfBlock: reasonOfBlock),
        callback: (p0) {
          disableDialogLoading = true;
          if (p0.success == true) {
            setState(() {
              widget.userData?.isBlocked =
                  !(widget.userData?.isBlocked ?? false);
              widget.onUpdate!(p0.data!);
            });
          } else {
            snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
          }
        });
  }

  // @override
  // observer() {
  //   super.observer();
    // bloc.signInStream.stream.listen((event) {
    //   if (event.success == true && event.data?.user != null) {
    //     $user.saveDetails(event.data!.user!);
    //     $user.saveToken(event.data!.token!);
    //     updateFcmToken();
    //     navigate(const Home());
    //   } else {
    //     snackBar(
    //         $strings.failed, event.message ?? $strings.SOME_THING_WENT_WRONG);
    //   }
    // });
  // }

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

  _onGenderChange(SelectionModel? gender) {
    setState(() {
      _gender = gender;
    });
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _dobNoController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
