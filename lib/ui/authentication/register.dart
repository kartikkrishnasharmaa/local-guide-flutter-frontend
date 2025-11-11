import 'package:flutter/gestures.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/utils/validator.dart';
import 'package:localguider/values/assets.dart';
import '../../base/base_state.dart';
import '../../blocs/auth_bloc.dart';
import '../../components/custom_text.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../../style/colors.dart';
import '../privacy/simple_text_viewer.dart';
import 'otp_verify_view.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends BaseState<Register, AuthBloc> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool privacyPolicyCheck = true;

  @override
  void init() {
    disableDialogLoading = true;
  }

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
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(sizing(20, context)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: CustomText(
                          $strings.register,
                          fontSize: sizing(30, context),
                          color: $styles.colors.white,
                          align: TextAlign.center,
                        ),
                      ),
                      gap(context, height: 30),
                      CustomText(
                        $strings.fullName,
                        color: $styles.colors.yellow,
                      ),
                      gap(context, height: 5),
                      InputField(
                          hint: $strings.pleaseEnterYourName,
                          disableLabel: true,
                          radius: sizing(30, context),
                          iconStart: Container(
                              width: sizing(20, context),
                              height: sizing(20, context),
                              alignment: Alignment.center,
                              child: CustomText("👤")),
                          maxLength: 40,
                          validator: (text) {
                            if (text?.isEmpty == true) {
                              return $strings.pleaseEnterYourName;
                            } else {
                              return null;
                            }
                          },
                          bgColor: $styles.colors.white,
                          controller: _nameController),
                      gap(context, height: 15),
                      CustomText(
                        $strings.phoneNumber,
                        color: $styles.colors.yellow,
                      ),
                      gap(context, height: 5),
                      InputField(
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
                      gap(context, height: 15),
                      CustomText(
                        $strings.password,
                        color: $styles.colors.yellow,
                      ),
                      gap(context, height: 5),
                      InputField(
                          hint: $strings.enterPassword,
                          isForPassword: true,
                          disableLabel: true,
                          radius: sizing(30, context),
                          iconStart: const Icon(Icons.password),
                          maxLength: 100,
                          validator: (text) {
                            if (text?.isEmpty == true) {
                              return $strings.pleaseEnterPassword;
                            } else if (text?.isValidPassword() != true) {
                              return "Password must be at least 8 characters";
                            } else {
                              return null;
                            }
                          },
                          bgColor: $styles.colors.white,
                          controller: _passwordController),
                      gap(context, height: 15),
                      CustomText(
                        $strings.confirmPassword,
                        color: $styles.colors.yellow,
                      ),
                      gap(context, height: 5),
                      InputField(
                          hint: $strings.confirmPassword,
                          isForPassword: true,
                          disableLabel: true,
                          radius: sizing(30, context),
                          iconStart: const Icon(Icons.password),
                          maxLength: 100,
                          validator: (text) {
                            if (text?.isEmpty == true) {
                              return $strings.pleaseEnterPassword;
                            } else if (text?.isValidPassword() != true) {
                              return "Password must be at least 8 characters";
                            } else if (text != _passwordController.text) {
                              return $strings.passwordsNotMatch;
                            } else {
                              return null;
                            }
                          },
                          bgColor: $styles.colors.white,
                          controller: _confirmPasswordController),
                      gap(context, height: 20),
                      Row(
                        children: [
                          Checkbox(
                              value: privacyPolicyCheck,
                              activeColor: $styles.colors.white,
                              checkColor: $styles.colors.yellow,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return $styles.colors.white;
                              }),
                              onChanged: (bool? value) {
                                setState(() {
                                  privacyPolicyCheck = value!;
                                });
                              }),
                          Flexible(
                            child: Text.rich(
                              overflow: TextOverflow.visible,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "By clicking the register button below, I hereby agree to all local guidelines ",
                                    style: $styles.text.getFontStyle(
                                        color: $styles.colors.white),
                                  ),
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: $styles.text.getFontStyle(
                                        color: $styles.colors.yellow,
                                        isUnderline: true),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        navigate(SimpleTextViewer(
                                            title: "Privacy & Policy",
                                            content: $appUtils
                                                    .getSettings()
                                                    ?.privacyPolicy ??
                                                ""));
                                      },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      gap(context, height: 15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultButton($strings.register,
                            textColor: $styles.colors.white,
                            radius: 30.0,
                            loadingController: bloc.loadingController,
                            bgColor: $styles.colors.yellow, onClick: () {
                          if (_formKey.currentState!.validate()) {
                            if (!privacyPolicyCheck) {
                              snackBar(
                                  "Error", "Please accept privacy policy.");
                              return;
                            }
                            _checkPhoneExist();
                          }
                        }),
                      ),
                      gap(context, height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            "Already have an account? ",
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
              ),
            )),
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
      if (event.success == true) {
        if (event.message == $strings.AUTO_FILL) {
          navigate(OTPVerifyView(
            phone: _phoneController.text.toString(),
            otp: event.other,
            name: _nameController.text,
            password: _passwordController.text.toString(),
            isRegister: true,
          ));
        } else if (event.message == $strings.CODE_SENT) {
          navigate(OTPVerifyView(
            phone: _phoneController.text.toString(),
            name: _nameController.text,
            password: _passwordController.text.toString(),
            isRegister: true,
          ));
        }
      } else {
        snackBar($strings.error, event.message!);
      }
    });
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  void observer() {
    super.observer();

    // bloc.firebaseOTPStream.stream.listen((event) {
    //
    // });

    bloc.phoneExistStream.stream.listen((event) {
      if (event.success == false) {
        _sendOTP();
      } else {
        snackBar($strings.failed, "Phone number already exist. Please login.");
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    bloc.dispose();
    super.dispose();
  }
}
