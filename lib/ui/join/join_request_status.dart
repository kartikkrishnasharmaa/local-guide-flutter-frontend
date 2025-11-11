import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';
import 'package:localguider/ui/dashboard/appointment_requests_main_page.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/ui/enums/approval_status.dart';
import 'package:localguider/ui/home/home.dart';
import 'package:localguider/ui/join/join_us.dart';
import 'package:localguider/ui/reviews/review_on_details.dart';
import 'package:localguider/ui/services/services_list.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/app_state.dart';
import 'package:localguider/utils/extensions.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../modals/reason_of_block.dart';
import '../../modals/reason_of_decline.dart';
import '../../models/requests/update_user_request_dto.dart';
import '../../responsive.dart';
import '../../style/styles.dart';
import '../authentication/user_information.dart';
import '../dashboard/appointment_requests.dart';
import '../gallery/full_image_view.dart';
import '../payments/transactions.dart';

class JoinRequestStatus extends StatefulWidget {
  UserRole userRole;
  String dtoId;
  bool isAdmin = false;
  Function()? refreshCallback;

  JoinRequestStatus(
      {super.key,
      required this.userRole,
      required this.dtoId,
      this.isAdmin = false,
      this.refreshCallback});

  @override
  State<JoinRequestStatus> createState() => _JoinRequestStatusState();
}

class _JoinRequestStatusState extends BaseState<JoinRequestStatus, AdminBloc> {
  PhotographerDto? dto;
  AppState _state = AppState.FETCHING_DATA;
  UserData? _userData;
  List<PlaceModel> _places = [];

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  void postFrame() {
    super.postFrame();
    _getData();
  }

  _getData() {
    bloc.getPhotographerDetails(widget.userRole, widget.dtoId, (p0) {
      if (p0.success == true) {
        _state = AppState.DATA_READY;
        dto = p0.data;
        bloc.getPlacesByIds(dto?.places ?? "", (response) {
          if (response.success == true) {
            _places = response.data ?? [];
            bloc.getAccountDetails(dto?.userId.toString(),
                (BaseCallback<UserData> response) {
              if (response.success == true) {
                _userData = response.data;
                setState(() {});
              }
            });
          }
        });
      } else {
        _state = AppState.DATA_NOT_FETCHED;
        setState(() {});
      }
    });
  }

  @override
  AdminBloc setBloc() => AdminBloc();

  @override
  Widget view() {
    return Scaffold(
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
          "${dto?.approvalStatus != ApprovalStatus.approved.value && _state == AppState.DATA_READY ? (widget.isAdmin ? "" : "Request for") : ""} ${widget.userRole == UserRole.PHOTOGRAPHER ? "Photographer" : "Guider"}",
          style: FontStyles.regular,
          color: $styles.colors.white,
        ),
      ),
      body: _state == AppState.FETCHING_DATA
          ? Center(
              child: Padding(
              padding: EdgeInsets.all(sizing(40, context)),
              child: CircularProgressIndicator(
                color: $styles.colors.black,
              ),
            ))
          : _state == AppState.DATA_NOT_FETCHED
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.all(sizing(20, context)),
                  child: CustomText("Not able to fetch request details."),
                ))
              : Stack(
                  children: [
                    Positioned(
                      top: 1,
                      left: 1,
                      right: 1,
                      bottom: $isAdmin &&
                              dto?.approvalStatus ==
                                  ApprovalStatus.inReview.value
                          ? 70
                          : 1,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(sizing(15, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gap(context, height: 20),
                              Row(
                                children: [
                                  CustomText("Status: ",
                                      color: $styles.colors.black,
                                      fontSize: sizing(20, context)),
                                  const Spacer(),
                                  CustomText(dto?.approvalStatus ?? "",
                                      color: $getApprovalStatusColor(
                                          dto?.approvalStatus),
                                      style: FontStyles.openSansMedium,
                                      fontSize: sizing(20, context)),
                                ],
                              ),
                              if (dto?.approvalStatus ==
                                  ApprovalStatus.declined.value)
                                gap(context, height: 15),
                              if (dto?.approvalStatus ==
                                  ApprovalStatus.declined.value)
                                Container(
                                  padding: EdgeInsets.all(sizing(10, context)),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: $styles.colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          sizing(10, context))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: $styles.colors.red,
                                          ),
                                          gap(context, width: 10),
                                          CustomText("Request was declined!",
                                              style: FontStyles.medium,
                                              color: $styles.colors.red)
                                        ],
                                      ),
                                      if (dto?.reasonOfDecline != null)
                                        gap(context, height: 10),
                                      if (dto?.reasonOfDecline != null)
                                        CustomText(dto?.reasonOfDecline ?? "",
                                            color: $styles.colors.red)
                                    ],
                                  ),
                                ),
                              gap(context, height: 10),
                              _infoRow("Firm name", dto?.firmName),
                              gap(context, height: 10),
                              _infoRow("Email", dto?.email),
                              gap(context, height: 10),
                              _infoRow("Phone number", dto?.phone),
                              gap(context, height: 10),
                              _infoRow("Address", dto?.address),
                              gap(context, height: 10),
                              _infoRow("Places of Service", "👇🏻"),
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
                              ),
                              gap(context, height: 14),
                              CustomText(
                                "About:",
                                fontSize: sizing(20, context),
                                style: FontStyles.openSansMedium,
                              ),
                              CustomText(
                                dto?.description ?? "",
                                fontSize: sizing(17, context),
                                color: $styles.colors.greyStrong,
                              ),
                              gap(context, height: 20),
                              CustomText(
                                "Featured Image:",
                                fontSize: sizing(20, context),
                                style: FontStyles.openSansMedium,
                              ),
                              gap(context, height: 10),
                              InkWell(
                                onTap: () {
                                  navigate(FullImageView(
                                    imageUrl: [
                                      dto!.featuredImage.appendRootUrl(),
                                      dto!.idProofFront.appendRootUrl(),
                                      dto!.idProofBack.appendRootUrl(),
                                      dto!.photograph.appendRootUrl(),
                                    ],
                                    currentPosition: 0,
                                  ));
                                },
                                child: SizedBox(
                                  height: sizing(170, context),
                                  width: sizing(200, context),
                                  child: ClipRRect(
                                    child: AppImage(
                                      image: NetworkImage(
                                          dto!.featuredImage.appendRootUrl()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              gap(context, height: 15),
                              CustomText(
                                "Id Proofs",
                                fontSize: sizing(20, context),
                                style: FontStyles.openSansMedium,
                              ),
                              gap(context, height: 10),
                              CustomText(
                                "Front",
                                fontSize: sizing(15, context),
                                style: FontStyles.openSansMedium,
                              ),
                              gap(context, height: 10),
                              InkWell(
                                onTap: () {
                                  navigate(FullImageView(
                                    imageUrl: [
                                      dto!.featuredImage.appendRootUrl(),
                                      dto!.idProofFront.appendRootUrl(),
                                      dto!.idProofBack.appendRootUrl(),
                                      dto!.photograph.appendRootUrl(),
                                    ],
                                    currentPosition: 1,
                                  ));
                                },
                                child: SizedBox(
                                  height: sizing(150, context),
                                  width: sizing(300, context),
                                  child: ClipRRect(
                                    child: AppImage(
                                      image: NetworkImage(
                                          dto!.idProofFront.appendRootUrl()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              gap(context, height: 10),
                              CustomText(
                                "Rear",
                                fontSize: sizing(15, context),
                                style: FontStyles.openSansMedium,
                              ),
                              gap(context, height: 10),
                              InkWell(
                                onTap: () {
                                  navigate(FullImageView(
                                    imageUrl: [
                                      dto!.featuredImage.appendRootUrl(),
                                      dto!.idProofFront.appendRootUrl(),
                                      dto!.idProofBack.appendRootUrl(),
                                      dto!.photograph.appendRootUrl(),
                                    ],
                                    currentPosition: 2,
                                  ));
                                },
                                child: SizedBox(
                                  height: sizing(150, context),
                                  width: sizing(300, context),
                                  child: ClipRRect(
                                    child: AppImage(
                                      image: NetworkImage(
                                          dto!.idProofBack.appendRootUrl()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              gap(context, height: 20),
                              CustomText(
                                "Photograph:",
                                fontSize: sizing(20, context),
                                style: FontStyles.openSansMedium,
                              ),
                              gap(context, height: 10),
                              InkWell(
                                onTap: () {
                                  navigate(FullImageView(
                                    imageUrl: [
                                      dto!.featuredImage.appendRootUrl(),
                                      dto!.idProofFront.appendRootUrl(),
                                      dto!.idProofBack.appendRootUrl(),
                                      dto!.photograph.appendRootUrl(),
                                    ],
                                    currentPosition: 3,
                                  ));
                                },
                                child: SizedBox(
                                  height: sizing(200, context),
                                  width: sizing(200, context),
                                  child: ClipRRect(
                                    child: AppImage(
                                      image: NetworkImage(
                                          dto!.photograph.appendRootUrl()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              gap(context, height: 20),
                              if (widget.isAdmin) _adminActionBtn(),
                              if (widget.isAdmin) gap(context, height: 20),
                              if (widget.isAdmin)
                                ReviewOnDetails(
                                  onRatingChange: (newRating) {},
                                  photographerId:
                                      widget.userRole == UserRole.PHOTOGRAPHER
                                          ? dto?.id.toString()
                                          : null,
                                  guiderId: widget.userRole == UserRole.GUIDER
                                      ? dto?.id.toString()
                                      : null,
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if ($isAdmin &&
                        dto?.approvalStatus == ApprovalStatus.inReview.value)
                      Positioned(
                        bottom: 15,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: DefaultButton("Accept", onClick: () {
                                _onStatusChange(true, false);
                              }),
                            ),
                            gap(context, width: 10),
                            Expanded(
                              child: DefaultButton("Decline",
                                  bgColor: $styles.colors.red, onClick: () {
                                _onStatusChange(false, true);
                              }),
                            ),
                          ],
                        ),
                      )
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
                userRole: widget.userRole,
                dtoId: dto?.id.toString(),
              ));
            }),
            gap(context, width: 10),
            DefaultButton("View Appointments", onClick: () {
              navigate(AppointmentRequestsMainPage(
                role: widget.userRole,
                dtoId: dto?.id.toString(),
                initialStatus: AppointmentStatus.requested,
              ));
            }),
          ],
        ),
        gap(context, height: 10),
        Row(
          children: [
            DefaultButton("Services and Plans", onClick: () {
              navigate(ServicesList(userRole: widget.userRole, dto: dto));
            }),
            gap(context, width: 10),
            DefaultButton("Edit Details", onClick: () {
              navigate(JoinUs(
                userRole: widget.userRole,
                dto: dto,
                refreshCallback: () {
                  _getData();
                },
              ));
            }),
          ],
        ),
        gap(context, height: 10),
        Row(
          children: [
            DefaultButton(_userData?.isBlocked == true ? "Unblock" : "Block",
                bgColor: _userData?.isBlocked == true
                    ? $styles.colors.green
                    : $styles.colors.red, onClick: () {
              if (_userData?.isBlocked == true) {
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
    bloc.updateUserInfo(
        request: UpdateUserRequestDto(
            userId: _userData?.id.toString(),
            isBlocked: !(_userData?.isBlocked ?? false),
            reasonOfBlock: reasonOfBlock),
        callback: (p0) {
          disableDialogLoading = true;
          if (p0.success == true) {
            setState(() {
              _userData?.isBlocked = !(_userData?.isBlocked ?? false);
            });
          } else {
            snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
          }
        });
  }

  void _onStatusChange(accept, decline) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: accept ? "Accept Request!" : "Decline Request",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc:
                "Are you sure you want to ${accept ? "Accept" : "Decline"} this request?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
              if (decline == true) {
                Get.dialog(
                    barrierDismissible: false,
                    Dialog(
                        backgroundColor: $styles.colors.white,
                        child: ReasonOfDecline(
                            title: "Reason of Decline!",
                            onDone: (text) {
                              $logger.log(
                                  message:
                                      "message >>>>>>>>>>>>>>>>>>>> Done Click");
                              _respond(accept, decline, text);
                            })));
              } else {
                _respond(accept, decline, null);
              }
            },
            btnCancelOnPress: () {})
        .show();
  }

  void _respond(accept, decline, reason) {
    bloc.respondToPhotographer(
        widget.userRole,
        dto?.id.toString(),
        accept ? ApprovalStatus.approved.value : ApprovalStatus.declined.value,
        reason, (p0) {
      if (p0.success == true) {
        snackBar(accept ? "Accepted!" : "Declined!", "Request status updated");
        if (widget.refreshCallback != null) {
          widget.refreshCallback!();
        }
        setState(() {
          dto?.approvalStatus = accept
              ? ApprovalStatus.approved.value
              : ApprovalStatus.declined.value;
          dto?.reasonOfDecline = reason;
        });
      } else {
        snackBar("Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  Widget _infoRow(title, value) {
    return Row(
      children: [
        CustomText("$title: ",
            color: $styles.colors.black, fontSize: sizing(20, context)),
        const Spacer(),
        CustomText(value ?? "", fontSize: sizing(20, context)),
      ],
    );
  }
}
