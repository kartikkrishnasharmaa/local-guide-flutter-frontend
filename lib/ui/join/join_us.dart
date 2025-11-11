import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/divider.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/join/join_request_sent.dart';
import 'package:localguider/ui/join/join_request_status.dart';
import 'package:localguider/ui/join/select_id_proofs.dart';
import 'package:localguider/ui/join/select_photograph.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../models/response/service_dto.dart';
import 'basic_information_to_join.dart';

class JoinUs extends StatefulWidget {
  UserRole userRole;
  PhotographerDto? dto;
  Function? refreshCallback;

  JoinUs({super.key, required this.userRole, this.dto, this.refreshCallback});

  @override
  State<JoinUs> createState() => _JoinUsState();
}

class _JoinUsState extends BaseState<JoinUs, HomeBloc> {
  // Page 1 Data
  Uint8List? featuredImage;
  String firmName = "";
  String email = "";
  String phone = "";
  String address = "";
  String description = "";
  List<ServiceDto> _services = [];
  List<PlaceModel> _places = [];

  // Page 2 Data
  String idProofType = "Aadhaar Card";
  Uint8List? idProofFront;
  Uint8List? idProofBack;

  // Page 3 Data
  Uint8List? photograph;

  final PageController _containerPageController =
      PageController(keepPage: true);

  final pages = [];

  final GlobalKey<FormState> _basicInformationFormKey = GlobalKey<FormState>();

  var pageIndex = 0;

  bool isKeyboardOpen = false;

  bool isEdit = false;

  @override
  void init() {
    isEdit = widget.dto != null;
    pages.addAll([
      BasicInformationToJoin(
        formKey: _basicInformationFormKey,
        onInfoUpdate: _onBasicInfoUpdate,
        dto: widget.dto,
        userRole: widget.userRole,
      ),
      SelectIdProofs(
        onIdProofUpdate: _onIdProofUpdates,
        dto: widget.dto,
      ),
      SelectPhotograph(
        onPhotographUpdate: _onPhotographUpdate,
        dto: widget.dto,
      ),
    ]);
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: $styles.colors.blueBg,
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
        toolbarHeight: 70,
        title: CustomText(
          isEdit ? "Edit Profile Details" : "Join Us",
          style: FontStyles.regular,
          fontSize: sizing(22, context),
          color: $styles.colors.white,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: isKeyboardOpen ? 1 : .88,
              alignment: FractionalOffset.topCenter,
              child: PageView(
                controller: _containerPageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [...pages],
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: .12,
              alignment: FractionalOffset.bottomCenter,
              child: Stack(
                children: [
                  divider(thickness: 1, color: $styles.colors.greyLight),
                  Center(
                    child: Row(
                      children: [
                        if (pageIndex > 0)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: sizing(8, context),
                                right: sizing(4, context),
                              ),
                              child: DefaultButton("Previous",
                                  iconStart: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: $styles.colors.white,
                                    size: sizing(15, context),
                                  ), onClick: () {
                                if (pageIndex > 0) {
                                  pageIndex--;
                                  _containerPageController
                                      .jumpToPage(pageIndex);
                                }
                              }),
                            ),
                          ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: sizing(4, context),
                              right: sizing(8, context),
                            ),
                            child: DefaultButton(
                                isEdit
                                    ? "Update"
                                    : pageIndex == pages.length - 1
                                        ? "Submit"
                                        : "Next",
                                iconEnd: Icon(
                                  pageIndex == pages.length - 1 || isEdit
                                      ? Icons.check_rounded
                                      : Icons.arrow_forward_ios,
                                  color: $styles.colors.white,
                                  size: sizing(15, context),
                                ), onClick: () {
                              if (isEdit) {
                                if (_validateBasicInfo()) {
                                  _update();
                                }
                                return;
                              }
                              if (pageIndex == 0 && !_validateBasicInfo()) {
                                return;
                              } else if (pageIndex == 1 &&
                                  !_validateIdProofs()) {
                                return;
                              } else if (pageIndex == 2 &&
                                  !_validatePhotograph()) {
                                return;
                              }
                              if (pageIndex == pages.length - 1) {
                                _submit();
                              } else {
                                if (pageIndex < pages.length - 1) {
                                  pageIndex++;
                                  _containerPageController
                                      .jumpToPage(pageIndex);
                                }
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _validateBasicInfo() {
    if (_basicInformationFormKey.currentState?.validate() != true) {
      return false;
    }
    if (!isEdit && featuredImage == null) {
      snackBar("Failed", "Feature image is required.");
      return false;
    }
    if (_places.isNullOrEmpty()) {
      snackBar("Failed",
          "Please select at least one place where you are providing services.");
      return false;
    }
    if (!isEdit && _services.isNullOrEmpty()) {
      snackBar("Failed", "Please add at least one service.");
      return false;
    }
    return true;
  }

  bool _validateIdProofs() {
    if (idProofType.isEmpty) {
      snackBar("Failed", "Please select the id proof type.");
      return false;
    }
    if (idProofFront == null && idProofBack == null) {
      snackBar("Failed", "Please upload both side image of $idProofType.");
      return false;
    }
    if (idProofFront == null) {
      snackBar("Failed", "Please upload the front side image of $idProofType.");
      return false;
    }
    if (idProofBack == null) {
      snackBar("Failed", "Please upload the back side image of $idProofType.");
      return false;
    }
    return true;
  }

  bool _validatePhotograph() {
    if (photograph == null) {
      snackBar("Failed", "Please upload your photograph.");
      return false;
    }
    return true;
  }

  _onBasicInfoUpdate(
      Uint8List? featuredImage,
      String firmName,
      String email,
      String phone,
      String address,
      String description,
      List<ServiceDto> services,
      List<PlaceModel> places) {
    this.featuredImage = featuredImage;
    this.firmName = firmName;
    this.email = email;
    this.phone = phone;
    this.address = address;
    this.description = description;
    _services = services;
    _places = places;
  }

  _onIdProofUpdates(
    String type,
    Uint8List? frontImage,
    Uint8List? backImage,
  ) {
    idProofType = type;
    idProofFront = frontImage;
    idProofBack = backImage;
  }

  _onPhotographUpdate(Uint8List? photograph) {
    this.photograph = photograph;
  }

  _submit() {
    String places = "";

    for (var e in _places) {
      places += "${e.id},";
    }
    places = places.substring(0, places.length - 1);

    $logger.log(message: "message $idProofType");
    bloc.applyForPhotographerOrGuider(
        user.id.toString(),
        widget.userRole,
        featuredImage!,
        firmName,
        email,
        phone,
        address,
        _places.first.id.toString(),
        places,
        description,
        _services,
        idProofType,
        idProofFront!,
        idProofBack!,
        photograph!);
  }

  _update() {
    String places = "";

    for (var e in _places) {
      places += "${e.id},";
    }

    places = places.substring(0, places.length - 1);
    $logger.log(message: "message $idProofType");
    bloc.updatePhotographerOrGuider(
        widget.dto!.id!.toInt(),
        widget.userRole,
        firmName,
        email,
        phone,
        _places.first.id.toString(),
        places,
        description,
        featuredImage, (response) {
      if (response.success == true) {
        snackBar("Success", "Details Updated Successfully");
        navigatePop(context);
      }
    });
  }

  @override
  void observer() {
    super.observer();
    bloc.photographersDetailsStream.stream.listen((p0) {
      $logger.log(message: "message 2 ${p0?.success}");
      if (p0?.success == true && p0 != null) {
        UserData updatedUser = user;
        if (widget.userRole == UserRole.PHOTOGRAPHER) {
          updatedUser.pid = p0.data?.id;
          updatedUser.photographer = false;
        } else {
          updatedUser.gid = p0.data?.id;
          updatedUser.guider = false;
        }
        $user.saveDetails(updatedUser);
        $logger.log(
            message:
                "message 3 ${p0.success} ${p0.data?.id} ${updatedUser.toJson().toString()}");
        if (widget.refreshCallback != null) widget.refreshCallback!();
        navigate(
            JoinRequestStatus(
                userRole: widget.userRole, dtoId: p0.data!.id.toString()),
            finish: true);
      } else {
        snackBar("Failed", p0?.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }
}
