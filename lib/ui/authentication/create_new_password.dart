import 'package:localguider/components/app_image.dart';
import 'package:localguider/ui/authentication/login.dart';
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

class CreateNewPassword extends StatefulWidget {
  String phoneNumber;

  CreateNewPassword({super.key, required this.phoneNumber});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends BaseState<CreateNewPassword, AuthBloc> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(sizing(20, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        "Create New Password",
                        fontSize: sizing(30, context),
                        color: $styles.colors.white,
                        align: TextAlign.center,
                      ),
                    ),
                    gap(context, height: 30),
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
                            return $strings.enterValidPassword;
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
                            return $strings.enterValidPassword;
                          } else if (text != _passwordController.text) {
                            return $strings.passwordsNotMatch;
                          } else {
                            return null;
                          }
                        },
                        bgColor: $styles.colors.white,
                        controller: _confirmPasswordController),
                    gap(context, height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultButton("Submit",
                          textColor: $styles.colors.white,
                          radius: 30.0,
                          loadingController: bloc.loadingController,
                          bgColor: $styles.colors.yellow, onClick: () {
                        if (_formKey.currentState!.validate()) {
                          _createNewPassword();
                        }
                      }),
                    ),
                    gap(context, height: 10),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  _createNewPassword() {
    hideKeyboard();
    bloc.forgetPassword(widget.phoneNumber, _passwordController.text.toString(),
        (p0) {
      if (p0.success == true) {
        snackBar("Success!", "Password changed successfully");
        showAlertDialog(
            title: Center(
                child: CustomText(
              "Success!",
              fontSize: sizing(16, context),
              color: $styles.colors.title,
              align: TextAlign.center,
              isBold: true,
            )),
           barrierDismissible: false,
           dialog:  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  "Password changed successfully. You can now login with your new password.",
                  fontSize: sizing(16, context),
                  color: $styles.colors.title,
                  align: TextAlign.center,
                ),
                gap(context, height: 10),
                DefaultButton("Login",
                    padding: 9,
                    bgColor: $styles.colors.blue,
                    textColor: $styles.colors.white, onClick: () {
                  navigate(const Login(), finishAffinity: true);
                })
              ],
            ));
      } else {
        snackBar("Error", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    bloc.dispose();
    super.dispose();
  }
}
