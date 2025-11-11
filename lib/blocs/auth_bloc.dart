import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:localguider/maps/map_repo.dart';
import 'package:localguider/maps/places_response.dart';
import 'package:localguider/models/requests/login_request_dto.dart';
import 'package:localguider/models/requests/register_request_dto.dart';
import 'package:localguider/models/requests/update_user_request_dto.dart';
import 'package:localguider/models/response/sign_in_response.dart';

import '../base/base_bloc.dart';
import '../base/base_callback.dart';
import '../main.dart';
import '../models/response/user_data.dart';
import '../network/repository/auth_repository.dart';
import '../ui/home/home.dart';

class AuthBloc extends BaseBloc {
  final StreamController<BaseCallback<UserCredential>> socialAuthStream =
      StreamController<BaseCallback<UserCredential>>.broadcast();

  final StreamController<BaseCallback<SignInResponse>> signInStream =
      StreamController<BaseCallback<SignInResponse>>.broadcast();

  final StreamController<BaseCallback<UserData>> otpStream =
      StreamController<BaseCallback<UserData>>.broadcast();

  final StreamController<BaseCallback<UserData>> userStream =
      StreamController<BaseCallback<UserData>>.broadcast();

  final StreamController<BaseCallback<dynamic>> phoneExistStream =
      StreamController<BaseCallback<dynamic>>.broadcast();

  final StreamController<int?> resentTimeStream =
      StreamController<int?>.broadcast();

  final StreamController<BaseListCallback<Predictions>?> placesResponseStream =
      StreamController<BaseListCallback<Predictions>?>.broadcast();

  final otpResendDuration = 60;

  static String? _verificationId;
  static int? _resendToken;
  // final StreamController<BaseCallback<dynamic>> firebaseOTPStream =
  //     StreamController<BaseCallback<dynamic>>.broadcast();

  sendFirebaseOTP(String phone, Function(BaseCallback) callback) async {
    $logger.log(message: "Phone ------> $phone");
    showLoading();
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: '+91 $phone',
      timeout: Duration(seconds: otpResendDuration),
      verificationCompleted: (PhoneAuthCredential credential) {
        $logger.log(message: "Access Token ${credential.accessToken}");
        dismissLoading();
        if (credential.smsCode != null) {
          // Future.delayed(const Duration(seconds: 1), () {
          //   callback(BaseCallback(
          //       success: true,
          //       other: credential.smsCode,
          //       message: $strings.AUTO_FILL));
          // });
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        dismissLoading();
        callback(BaseCallback(
          success: false,
          message: e.toString(),
        ));
      },
      forceResendingToken: _resendToken,
      codeSent: (String verificationId, int? resendToken) {
        dismissLoading();
        _verificationId = verificationId;
        _resendToken = resendToken;
        callback(BaseCallback(success: true, message: $strings.CODE_SENT));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    ).onError((error, stackTrace) {
      dismissLoading();
      callback(BaseCallback(
        success: false,
        message: error.toString(),
      ));
    });
  }

  verifyFirebaseOTP(
      {PhoneAuthCredential? credential,
      String? smsCode,
      required Function(BaseCallback) callback}) async {
    showLoading();
    PhoneAuthCredential? mkCredential;
    print("SMS Code <><><><    $smsCode");
    if (credential == null) {
      mkCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: smsCode!);
    }
    print(">>>>>>>>>>> ${credential ?? mkCredential}");
    FirebaseAuth.instance
        .signInWithCredential(credential ?? mkCredential!)
        .then((value) {
      print(value as dynamic);
      dismissLoading();
      callback(BaseCallback(
        success: true,
      ));
    }, onError: (error) {
      dismissLoading();
      callback(BaseCallback(
        success: false,
        message: $strings.inCorrectOTP,
      ));
    });
  }

  login({LoginRequestDto? request}) async {
    showLoading();
    AuthRepository.login((response) {
      dismissLoading();
      signInStream.add(response);
    }, request: request);
  }

  register({RegisterRequestDto? request}) async {
    showLoading();
    AuthRepository.register((response) {
      dismissLoading();
      signInStream.add(response);
    }, request: request);
  }

  forgetPassword(phoneNumber, newPassword,
      Function(BaseCallback<UserData>) callback) async {
    showLoading();
    AuthRepository.forgetPassword(phoneNumber, newPassword, (response) {
      dismissLoading();
      callback(response);
    });
  }
  
  updateUser(
      {required UpdateUserRequestDto request,
      required Function(BaseCallback<UserData>) callback,
      disableLoading = false}) async {
    if (!disableLoading) showLoading();
    AuthRepository.updateUser(request, (response) {
      dismissLoading();
      callback(response);
      Future.delayed(const Duration(milliseconds: 300), () {
        infoUpdated.add(true);
      });
    });
  }

  checkPhoneExist(String phone) {
    showLoading();
    AuthRepository.checkPhoneExists(phone, (response) {
      if (response.success == null) return;
      dismissLoading();
      phoneExistStream.add(response);
    });
  }

  findPlaces(String keyword, bool cities) {
    showLoading();
    MapRepo.searchPlaces(keyword, cities, (response) {
      $logger.log(message: "Places Response ${response.toString()}");
      if (response.success == null) return;
      dismissLoading();
      placesResponseStream.add(response);
    });
  }

  @override
  dispose() {
    socialAuthStream.close();
    otpStream.close();
    userStream.close();
    resentTimeStream.close();
    phoneExistStream.close();
  }
}
