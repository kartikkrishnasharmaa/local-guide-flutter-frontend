import 'dart:async';
import 'package:get/get.dart';
import 'package:localguider/style/colors.dart';
import 'package:localguider/ui/authentication/create_new_password.dart';
import 'package:localguider/ui/authentication/user_information.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../base/base_state.dart';
import '../../blocs/auth_bloc.dart';
import '../../components/app_image.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../components/default_button.dart';
import '../../main.dart';
import '../../models/requests/register_request_dto.dart';
import '../../responsive.dart';
import '../../values/assets.dart';
import '../home/home.dart';

class OTPVerifyView extends StatefulWidget {

  String? name;
  String phone;
  String? otp;
  String? password;
  bool isRegister = false;

  OTPVerifyView(
      {super.key,
      required this.phone,
        this.name,
      this.otp,
      this.password,
      this.isRegister = false});

  @override
  State<OTPVerifyView> createState() => _OTPVerifyViewState();
}

class _OTPVerifyViewState extends BaseState<OTPVerifyView, AuthBloc> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  Timer? _resendTimer;
  int _start = 60;

  @override
  void init() {
    disableDialogLoading = true;
    _start = bloc.otpResendDuration;
    _startResendTimer();
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  Widget view() {
    if (widget.otp != null) {
      _otpPinFieldController.currentState?.code = widget.otp!;
    }
    return Stack(
      children: [
        SizedBox(
            width: double.maxFinite,
            child: AppImage(
              image: AssetImage(Images.background),
              fit: BoxFit.fitWidth,
            )),
        Scaffold(
            backgroundColor: colorTransparent,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: colorTransparent,
              toolbarHeight: 100,
              leading: IconButton(
                onPressed: () {
                  navigatePop(context);
                },
                icon:
                    Icon(Icons.arrow_back_rounded, color: $styles.colors.white),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Center(
                  child: CustomText(
                    $strings.enter6DigitCode,
                    fontSize: sizing(30, context),
                    color: $styles.colors.white,
                    align: TextAlign.center,
                  ),
                ),
                gap(context, height: 10),
                CustomText(
                  "${$strings.otpVerifyMsg}\n+91 ${widget.phone}",
                  align: TextAlign.center,
                  color: $styles.colors.greyLight,
                ),
                gap(context, height: 30),
                OtpPinField(
                    key: _otpPinFieldController,
                    autoFillEnable: false,
                    fieldHeight: sizing(45, context),
                    fieldWidth: sizing(45, context),
                    textInputAction: TextInputAction.done,
                    onSubmit: (text) {},
                    onChange: (text) {},
                    otpPinFieldStyle: OtpPinFieldStyle(
                        defaultFieldBorderColor: $styles.colors.white,
                        activeFieldBorderColor: $styles.colors.white,
                        textStyle: TextStyle(
                            color: $styles.colors.white,
                            fontSize: subTitleSize()),
                        fieldBorderWidth: 1),
                    maxLength: 6,
                    showCursor: true,
                    cursorColor: $styles.colors.white,
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
                              ? $styles.colors.white
                              : (seconds == -1
                                  ? $styles.colors.green
                                  : $styles.colors.greyLight),
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
                      bgColor: $styles.colors.yellow, onClick: () {
                        if (_otpPinFieldController.currentState?.getPin().isNullOrEmpty() ==
                            false) {
                          _verifyOTP();
                        } else {
                          snackBar($strings.error, $strings.enterValidCorrectOTP);
                        }
                  }),
                ),
              ],
            )),
      ],
    );
  }

  _resendOTP() {
    bloc.sendFirebaseOTP(widget.phone, (event) {
      if(event.success == true) {
        if (event.message == $strings.CODE_SENT) {
          snackBar($strings.success, $strings.resendOTPSuccessfully);
        }
      } else {
        snackBar("Failed!", event.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
    _start = bloc.otpResendDuration;
    _startResendTimer();
  }

  _verifyOTP() {
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
        if (widget.isRegister) {
          // navigate(UserInformation(
          //   phone: widget.phone,
          //   password: widget.password!,
          // ));
          _register(widget.phone, widget.name, widget.password!);
        } else {
          // Change Password Screen
          navigate(
            CreateNewPassword(phoneNumber: widget.phone),
          );
        }
      });
    }
  }

  @override
  void observer() {
    super.observer();
    // bloc.firebaseOTPStream.stream.listen((event) {
    //   if (event.success == true) {
    //     // if (event.message == $strings.AUTO_FILL) {
    //     //   _otpPinFieldController.currentState?.text = event.other ?? "";
    //     // } else
    //     if (event.message == $strings.CODE_SENT) {
    //       snackBar($strings.success, $strings.resendOTPSuccessfully);
    //     }
    //   }
    // });
    bloc.userStream.stream.listen((event) {});

    bloc.signInStream.stream.listen((event) {
      if (event.success == true && event.data?.user != null) {
        $user.saveDetails(event.data!.user!);
        $user.saveToken(event.data!.token!);
        updateFcmToken();
        navigate(const Home());
      } else {
        snackBar(
            $strings.failed, event.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });

  }

  void _register(String phone, String? name, String password) {
    String username = generateUniqueUsername();
    RegisterRequestDto requestDto = RegisterRequestDto();
    requestDto.phone = phone;
    requestDto.name = name ?? createName(phone);
    requestDto.username = username;
    requestDto.countryCode = "+91";
    requestDto.latitude = 28.644800;
    requestDto.longitude = 	77.216721;
    requestDto.address = 	"New Delhi, India,";
    requestDto.password = password;
    bloc.register(request: requestDto);
  }

  String createName(String phone) {
    if (phone.length != 10) {
      throw ArgumentError("Phone number must be exactly 10 digits long");
    }
    var name = "user";
    var lastDigits = phone.substring(6, 10); // Extracts the last 4 digits
    return name + lastDigits;
  }

  String generateUniqueUsername() {
    var random = Random();
    int randomNumber = 100000 + random.nextInt(900000); // Generates a 6-digit random number
    return "usr$randomNumber";
  }

  _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _start--;
      bloc.resentTimeStream.add(_start);
      if (_start == -1) {
        timer.cancel();
        bloc.resentTimeStream.add(null);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _resendTimer?.cancel();
  }
}
