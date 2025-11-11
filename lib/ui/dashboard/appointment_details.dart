import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/models/response/appointment_response.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/utils/app_state.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../components/default_button.dart';
import '../../main.dart';
import '../../modals/reason_of_decline.dart';
import '../../responsive.dart';
import '../../style/styles.dart';
import '../../utils/time_utils.dart';

class AppointmentDetails extends StatefulWidget {

  AppointmentResponse appointment;
  bool showActionsBtn = true;
  Function? refreshCallback;
  PhotographerDto? dto;

  AppointmentDetails({super.key,
    required this.appointment,
    this.dto,
    this.showActionsBtn = true,
    this.refreshCallback});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends BaseState<AppointmentDetails, HomeBloc> {

  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  Timer? _resendTimer;
  int _startResendSeconds = 60;

  double hintSize = 12;
  double valueSize = 15;
  double itemGaps = 20;
  double hintValueGap = 10;

  bool _showOtpView = false;
  UserData? customerData;

  AppState _state = AppState.FETCHING_DATA;

  var isDeclined = false;

  @override
  void init() {
    _startResendSeconds = bloc.otpResendDuration;
    isDeclined =
        widget.appointment.appointmentStatus == AppointmentStatus.cancelled;
  }

  @override
  void postFrame() {
    bloc.getProfile(widget.appointment.userId.toString());
    super.postFrame();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: $styles.colors.blue,
        title: CustomText(
          "Appointment Details",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
      ),
      body: _state == AppState.FETCHING_DATA
          ? _loading()
          : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(sizing(15, context)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sizing(5, context)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText("Status: ",
                      color: $styles.colors.black,
                      fontSize: sizing(20, context)),
                  const Spacer(),
                  CustomText(
                      $getStatusText(
                          widget.appointment.appointmentStatus ?? ""),
                      color: $getAppointmentStatusColor(
                          widget.appointment.appointmentStatus),
                      style: FontStyles.openSansMedium,
                      fontSize: sizing(20, context)),
                ],
              ),
              if (isDeclined) gap(context, height: 15),
              if (isDeclined)
                Container(
                  padding: EdgeInsets.all(sizing(10, context)),
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: $styles.colors.red, width: 1),
                      borderRadius:
                      BorderRadius.circular(sizing(10, context))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: $styles.colors.red,
                          ),
                          gap(context, width: 10),
                          CustomText("Appointment was declined!",
                              style: FontStyles.medium,
                              color: $styles.colors.red)
                        ],
                      ),
                      if (widget.appointment.note != null)
                        gap(context, height: 10),
                      if (widget.appointment.note != null)
                        CustomText(widget.appointment.note ?? "",
                            color: $styles.colors.red)
                    ],
                  ),
                ),
              gap(context, height: 15),
              CustomText(
                "Appointment By",
                style: FontStyles.light,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                widget.appointment.customerName ?? "",
                isBold: true,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Selected Service",
                style: FontStyles.light,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              Container(
                padding: EdgeInsets.all(sizing(5, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizing(5, context)),
                  color: $styles.colors.green.withOpacity(.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      widget.appointment.serviceName ?? "",
                      style: FontStyles.regular,
                      isBold: true,
                      fontSize: sizing(hintSize, context),
                    ),
                    CustomText(
                      "${widget.appointment.serviceCost?.toStringAsFixed(2) ??
                          "0.0"} ₹",
                      style: FontStyles.regular,
                      color: $styles.colors.green,
                      fontSize: sizing(hintSize, context),
                    ),
                  ],
                ),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Appointment Charge",
                style: FontStyles.light,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                "${widget.appointment.appointmentCharge?.toStringAsFixed(2)} ₹",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Total:",
                style: FontStyles.regular,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                "${widget.appointment.totalPayment?.toStringAsFixed(2)} ₹",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Payment Status",
                style: FontStyles.regular,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                widget.appointment.paymentStatus ?? "",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Appointment Date",
                style: FontStyles.light,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                TimeUtils.format(
                    TimeUtils.parseUtcToLocal(widget.appointment.date),
                    format: TimeUtils.dd_MM_yyyy_SLASHED),
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Appointment Time",
                style: FontStyles.light,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                TimeUtils.format(
                    TimeUtils.parseUtcToLocal(widget.appointment.date),
                    format: TimeUtils.hhmma),
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              CustomText(
                "Appointment Requested On",
                style: FontStyles.light,
                fontSize: hintSize,
              ),
              gap(context, height: hintValueGap),
              CustomText(
                TimeUtils.format(widget.appointment.createdOn!,
                    format: TimeUtils.MMM_dd_yyyy_hh_mm_a),
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
              gap(context, height: itemGaps),
              if (widget.showActionsBtn &&
                  widget.appointment.appointmentStatus !=
                      AppointmentStatus.requested &&
                  widget.appointment.appointmentStatus !=
                      AppointmentStatus.cancelled)
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(sizing(10, context)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: $styles.colors.borderColor(), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Customer Contact:",
                        style: FontStyles.medium,
                        fontSize: sizing(valueSize, context),
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        "Customer Name",
                        style: FontStyles.light,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        customerData?.name ?? "",
                        style: FontStyles.regular,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        "Phone number",
                        style: FontStyles.light,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        customerData?.phone ?? "",
                        style: FontStyles.regular,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        "Email",
                        style: FontStyles.light,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        customerData?.email ?? "",
                        style: FontStyles.regular,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        "Address",
                        style: FontStyles.light,
                        fontSize: hintSize,
                      ),
                      gap(context, height: hintValueGap),
                      CustomText(
                        customerData?.address ?? "",
                        style: FontStyles.regular,
                        fontSize: hintSize,
                      ),
                    ],
                  ),
                ),
              gap(context, height: itemGaps),
              gap(context, height: 40),
              if (widget.appointment.appointmentStatus ==
                  AppointmentStatus.requested &&
                  widget.showActionsBtn)
                Row(
                  children: [
                    Expanded(
                      child: DefaultButton("Accept", onClick: () {
                        _onStatusChange(true, false, "");
                      }),
                    ),
                    gap(context, width: 10),
                    Expanded(
                      child: DefaultButton("Cancel",
                          bgColor: $styles.colors.red, onClick: () {
                            Get.dialog(
                                barrierDismissible: false,
                                Dialog(
                                    backgroundColor: $styles.colors.white,
                                    child: ReasonOfDecline(
                                        title: "Reason of Cancel!",
                                        onDone: (text) {
                                          _onStatusChange(false, true, text);
                                        })));
                          }),
                    ),
                  ],
                ),
              gap(context, height: 10),
              if (widget.appointment.appointmentStatus ==
                  AppointmentStatus.accepted ||
                  widget.appointment.appointmentStatus ==
                      AppointmentStatus.onGoing &&
                      widget.showActionsBtn)
                Row(
                  children: [
                    if (widget.appointment.appointmentStatus ==
                        AppointmentStatus.accepted)
                      Expanded(
                        child:
                        DefaultButton("Move to OnGoing", onClick: () {
                          _updateStatus(AppointmentStatus.onGoing, null);
                        }),
                      ),
                    gap(context, width: 10),
                    if (widget.appointment.appointmentStatus ==
                        AppointmentStatus.onGoing && !_showOtpView)
                      Expanded(
                        child: DefaultButton("Move to Completed",
                            bgColor: $styles.colors.green, onClick: () {
                              if (widget.dto != null) {
                                bloc.sendFirebaseOTP(
                                    "9090909090"/*widget.dto!.phone!*/, (callback) {
                                  if (callback.success == true) {
                                    _showOtpView = true;
                                    _startResendTimer();
                                    setState(() {});
                                  } else {
                                    snackBar("Failed!", callback.message ??
                                        $strings.SOME_THING_WENT_WRONG);
                                  }
                                });
                              } else {
                                _updateStatus(
                                    AppointmentStatus.completed, null);
                              }
                            }),
                      ),
                  ],
                ),
              if(_showOtpView) Column(
                children: [
                  gap(context, width: 15),
                  OtpPinField(
                      key: _otpPinFieldController,
                      autoFillEnable: false,
                      fieldHeight: sizing(45, context),
                      fieldWidth: sizing(45, context),
                      textInputAction: TextInputAction.done,
                      onSubmit: (text) {},
                      onChange: (text) {},
                      otpPinFieldStyle: OtpPinFieldStyle(
                          defaultFieldBorderColor: $styles.colors.black,
                          activeFieldBorderColor: $styles.colors.black,
                          textStyle: TextStyle(
                              color: $styles.colors.black,
                              fontSize: subTitleSize()),
                          fieldBorderWidth: 1),
                      maxLength: 6,
                      showCursor: true,
                      cursorColor: $styles.colors.black,
                      showCustomKeyboard: false,
                      mainAxisAlignment: MainAxisAlignment.center,
                      otpPinFieldDecoration:
                      OtpPinFieldDecoration.defaultPinBoxDecoration),
                  gap(context, height: 20),
                  StreamBuilder(
                      stream: bloc.resentTimeStream.stream,
                      builder: (context, snapshot) {
                        var text = "";
                        var seconds = snapshot.data;
                        if (seconds == null) {
                          text = $strings.resendOTP;
                        } else if (seconds < 60) {
                          text = "${$strings.resendOTPIn} ${snapshot.data}s";
                        } else if (seconds == -1) {
                          text = $strings.codeSent;
                        }
                        return CustomInkWell(
                          onTap: () {
                            if (text == $strings.resendOTP) {
                              _resendOTP();
                            }
                          },
                          child: CustomText(
                            text,
                            isUnderline: true,
                            color: seconds == null
                                ? $styles.colors.black
                                : (seconds == -1
                                ? $styles.colors.green
                                : $styles.colors.greyMedium),
                          ),
                        );
                      }),
                  gap(context, height: 10),
                  Padding(
                    padding: EdgeInsets.all(sizing(20, context)),
                    child: DefaultButton($strings.verify,
                        textColor: $styles.colors.white,
                        radius: 30.0,
                        loadingController: bloc.loadingController,
                        bgColor: $styles.colors.yellow,
                        onClick: () {
                          if (_otpPinFieldController.currentState?.getPin()
                              .isNullOrEmpty() ==
                              false) {
                            _verifyOTP();
                          } else {
                            snackBar(
                                $strings.error, $strings.enterValidCorrectOTP);
                          }
                        }),
                  ),
                ],
              ),
              gap(context, height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
        child: Padding(
          padding: EdgeInsets.all(sizing(50, context)),
          child: CircularProgressIndicator(
            color: $styles.colors.blue,
          ),
        ));
  }

  _onStatusChange(accept, decline, reason) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        padding: EdgeInsets.all(sizing(15, context)),
        title: accept ? "Accept Appointment!" : "Cancel Appointment",
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
        "Are you sure you want to ${accept
            ? "Accept"
            : "Decline"} this request?",
        btnCancelText: "Not Now",
        btnOkText: "Yes",
        btnOkOnPress: () {
          _updateStatus(
              accept
                  ? AppointmentStatus.accepted
                  : AppointmentStatus.cancelled,
              reason);
        },
        btnCancelOnPress: () {})
        .show();
  }

  void _updateStatus(String status, String? note) {
    bloc.respondAppointment(
      widget.appointment.id.toString(),
      status,
      note,
          (p0) {
        if (p0.success == true) {
          if (widget.refreshCallback != null) {
            widget.refreshCallback!.call();
          }
          snackBar("Status updated", "Request status updated");
          _showOtpView = false;
          setState(() {
            widget.appointment.appointmentStatus = p0.data?.appointmentStatus;
          });
        } else {
          snackBar("Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
        }
      },
    );
  }

  _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _startResendSeconds--;
      bloc.resentTimeStream.add(_startResendSeconds);
      if (_startResendSeconds == -1) {
        timer.cancel();
        bloc.resentTimeStream.add(null);
      }
    });
  }

  _resendOTP() {
    bloc.sendFirebaseOTP( "9090909090"/*widget.dto!.phone!*/, (event) {
      if (event.success == true) {
        if (event.message == $strings.CODE_SENT) {
          snackBar($strings.success, $strings.resendOTPSuccessfully);
        }
      } else {
        snackBar("Failed!", event.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
    _startResendSeconds = bloc.otpResendDuration;
    _startResendTimer();
  }

  _verifyOTP() {
    disableDialogLoading = true;
    var userOTP = _otpPinFieldController.currentState?.getPin();
    if (userOTP.isNullOrEmpty() || userOTP?.length != 6) {
      Get.snackbar(
        $strings.error,
        $strings.enterValidCorrectOTP,
      );
    } else {
      bloc.verifyFirebaseOTP(smsCode: userOTP!, callback: (event) {
        snackBar($strings.success, $strings.otpVerifiesSuccessfully);
        disableDialogLoading = false;
        _updateStatus(
            AppointmentStatus.completed, null);
      });
    }
  }

  @override
  void observer() {
    bloc.profileStream.stream.listen((event) {
      if (event?.success == true) {
        setState(() {
          customerData = event?.data;
          _state = AppState.DATA_READY;
        });
      } else {
        setState(() {
          _state = AppState.DATA_NOT_FETCHED;
        });
      }
    });
    super.observer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
