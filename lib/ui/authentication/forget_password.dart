import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/auth_bloc.dart';
import 'package:localguider/utils/validator.dart';

import '../../components/app_image.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../../style/colors.dart';
import '../../values/assets.dart';
import 'otp_verify_view.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends BaseState<ForgetPassword, AuthBloc> {
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void init() {}

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  Widget view() {
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
              icon: Icon(Icons.arrow_back_rounded, color: $styles.colors.white),
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: CustomText(
                    $strings.forgetPassword,
                    fontSize: sizing(30, context),
                    color: $styles.colors.white,
                    align: TextAlign.center,
                  ),
                ),
                Center(
                  child: CustomText(
                    $strings.forgetPasswordMsg,
                    color: $styles.colors.yellow,
                    align: TextAlign.center,
                  ),
                ),
                gap(context, height: 15),
                Padding(
                  padding: EdgeInsets.all(sizing(15, context)),
                  child: InputField(
                      hint: $strings.enterPhone,
                      isNumeric: true,
                      disableLabel: true,
                      radius: sizing(30, context),
                      iconStart: Container(
                          width: sizing(20, context),
                          height: sizing(20, context),
                          alignment: Alignment.center,
                          child: CustomText("🇮🇳")),
                      maxLength: 10,
                      validator: (text) {
                        if (text?.isEmpty == true) {
                          return $strings.pleaseEnterPhone;
                        } else if (text?.isValidPhoneNumber() != true) {
                          return $strings.enterValidPhone;
                        } else {
                          return null;
                        }
                      },
                      bgColor: $styles.colors.white,
                      controller: _phoneController),
                ),
                Padding(
                  padding: EdgeInsets.all(sizing(15, context)),
                  child: DefaultButton($strings.next,
                      textColor: $styles.colors.white,
                      radius: 30.0,
                      loadingController: bloc.loadingController,
                      bgColor: $styles.colors.yellow, onClick: () {
                    if (_formKey.currentState!.validate()) {
                      _checkPhoneExist();
                    }
                  }),
                ),
                gap(context, height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "Just remembered? ",
                      color: $styles.colors.white,
                    ),
                    CustomInkWell(
                        onTap: () {
                          navigatePop(context);
                        },
                        child: Center(
                            child: CustomText(
                          $strings.login,
                          color: $styles.colors.yellow,
                        ))),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _checkPhoneExist() {
    hideKeyboard();
    bloc.checkPhoneExist(_phoneController.text.toString());
  }

  _sendOTP() {
    hideKeyboard();
    bloc.sendFirebaseOTP(_phoneController.text.toString(), (event) {
      dismissLoading();
      $logger.log(message: "message>>>>>>>>  ${event.message}  ${event.data}");
      if (event.success == true) {
        // if (event.message == $strings.AUTO_FILL) {
        //   navigate(OTPVerifyView(
        //     phone: _phoneController.text.toString(),
        //     otp: event.other,
        //     isRegister: false,
        //   ));
        // } else
        if (event.message == $strings.CODE_SENT) {
          setState(() {
            navigate(OTPVerifyView(
              phone: _phoneController.text.toString(),
              otp: event.other,
              isRegister: false,
            ));
          });
        }
      } else {
        setState(() {
          snackBar($strings.error, event.message!);
        });
      }
    });
  }

  @override
  void observer() {
    // bloc.firebaseOTPStream.stream.listen((event) {
    //
    // });

    bloc.phoneExistStream.stream.listen((event) {
      if (event.success == false) {
        snackBar($strings.failed,
            "Phone number not linked with any account. Please register.");
      } else {
        _sendOTP();
      }
    });
    super.observer();
  }
}
