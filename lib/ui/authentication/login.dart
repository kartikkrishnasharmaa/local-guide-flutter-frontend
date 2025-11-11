import 'package:flutter/foundation.dart';
import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/models/requests/login_request_dto.dart';
import 'package:localguider/ui/admin/dashboard/admin_dashboard.dart';
import 'package:localguider/ui/authentication/forget_password.dart';
import 'package:localguider/ui/authentication/register.dart';
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
import '../home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends BaseState<Login, AuthBloc> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  Widget view() {
    if(kDebugMode) {
      _phoneController.text = "9024653150";
      _passwordController.text = "12345678";
    }
    return Stack(
      children: [
        if(!$isAdmin) SizedBox(
            width: double.maxFinite,
            child: AppImage(
              image: AssetImage(Images.background),
              fit: BoxFit.fitWidth,
            )),
        Scaffold(
            backgroundColor: colorTransparent,
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: Center(
              child: SizedBox(
                width: $isAdmin ? 500 : double.maxFinite,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(sizing(20, context)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(!$isAdmin)  Center(
                            child: CustomText(
                              "Guide what\nyou need!",
                              fontSize: sizing(30, context),
                              color: $styles.colors.white,
                              align: TextAlign.center,
                            ),
                          ),
                          gap(context, height: 40),
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
                                  return $strings.enterValidPassword;
                                } else {
                                  return null;
                                }
                              },
                              bgColor: $styles.colors.white,
                              controller: _passwordController),
                          gap(context, height: 20),
                          if(!$isAdmin)  CustomInkWell(
                              onTap: () {
                                navigate(const ForgetPassword());
                              },
                              child: Center(
                                  child: CustomText(
                                $strings.forgetPassword,
                                color: $styles.colors.yellow,
                              ))),
                          gap(context, height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultButton($strings.loginSecurely,
                                textColor: $styles.colors.white,
                                radius: 30.0,
                                loadingController: bloc.loadingController,
                                bgColor: $styles.colors.yellow, onClick: () {
                              if (_formKey.currentState!.validate()) {
                                bloc.login(
                                    request: LoginRequestDto(_phoneController.text.toString(),
                                        _passwordController.text.toString()));
                                hideKeyboard();
                              }
                            }),
                          ),
                          gap(context, height: 10),
                          if(!$isAdmin)  CustomInkWell(
                              onTap: () {
                                navigate(const Register());
                              },
                              child: Center(
                                  child: CustomText(
                                $strings.createAnAccount,
                                color: $styles.colors.white,
                                isBold: true,
                                fontSize: sizing(15, context),
                              ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  AuthBloc setBloc() => AuthBloc();

  @override
  void observer() {
    super.observer();

    bloc.signInStream.stream.listen((event) {
      if (event.success == true) {
        $user.saveDetails(event.data!.user!);
        $user.saveToken(event.data!.token!);
        navigate($isAdmin ? const AdminDashboard() : const Home());
      } else {
        snackBar($strings.failed, event.message ?? $strings.SOME_THING_WENT_WRONG);
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
