import 'package:dio/dio.dart';
import 'package:localguider/models/requests/login_request_dto.dart';
import 'package:localguider/models/requests/register_request_dto.dart';
import 'package:localguider/models/response/sign_in_response.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/utils/extensions.dart';
import '../../base/base_callback.dart';
import '../../main.dart';
import '../../models/requests/update_user_request_dto.dart';
import '../network_const.dart';

class AuthRepository {
  static login(Function(BaseCallback<SignInResponse>) callback,
      {LoginRequestDto? request}) async {
    if (request == null) {
      callback(BaseCallback<SignInResponse>(
        success: false,
        message: $strings.SOME_THING_WENT_WRONG,
      ));
      return;
    }

   $apiClient.post(EndPoints.LOGIN, data: request.toJson()).then((value) {
      value.parse<SignInResponse>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<SignInResponse>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<SignInResponse>(
          success: false, message: error.toString()));
    });
  }

  static register(Function(BaseCallback<SignInResponse>) callback,
      {RegisterRequestDto? request}) async {
    if (request == null) {
      callback(BaseCallback<SignInResponse>(
        success: false,
        message: $strings.SOME_THING_WENT_WRONG,
      ));
      return;
    }
    await $apiClient.post(EndPoints.REGISTER, data: request.toJson()).then((value) {
      value.parse<SignInResponse>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<SignInResponse>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<SignInResponse>(
          success: false, message: error.toString()));
    });
  }

   static forgetPassword(phoneNumber, newPassword, Function(BaseCallback<UserData>) callback) async {
    var request = {
      "phoneNumber": phoneNumber,
      "password": newPassword
    };
    await $apiClient.post(EndPoints.FORGET_PASSWORD, data: request).then((value) {
      value.parse<UserData>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<UserData>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<UserData>(
          success: false, message: error.toString()));
    });
  }

  static updateUser(UpdateUserRequestDto requestDto, Function(BaseCallback<UserData>) callback) async {
    var requestMap = requestDto.toJson();
    await $apiClient.post(EndPoints.UPDATE_USER, data: FormData.fromMap(requestMap)).then((value) {
      $logger.log(message: "UPDATE USER >>>>>>>>>>>>>  $value");
      value.parse<UserData>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<UserData>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<UserData>(
          success: false, message: error.toString()));
    });
  }

  static checkPhoneExists(
      String phone, Function(BaseCallback<dynamic>) callback) {
    return $apiClient.get(EndPoints.CHECK_PHONE_EXISTS + phone).then((value) {
      value.parseDynamic((response) {
        callback(response);
      });
    }).onError((error, stackTrace) {
      callback(BaseCallback(success: false, message: error.toString()));
      throw stackTrace;
    });
  }
}
