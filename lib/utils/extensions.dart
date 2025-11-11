import 'package:dio/dio.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../base/base_callback.dart';
import '../main.dart';
import '../models/serializable.dart';
import '../network/base_response.dart';
import '../network/base_string_response.dart';
import '../network/dio_client.dart';
import '../network/list_base_model.dart';
import '../network/network_utils.dart';
import '../network/root_response.dart';
import 'app_utils.dart';

extension StringExtensions on String {
  String rupeeSuffix() {
    return "$this₹";
  }

  String rupeePrefix() {
    return "₹$this";
  }

  String appendRootUrl() {
    return "${DioClient.baseUrl}image/download/$this";
  }

  bool isNumberOnly() {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }
  String mkFirstLetterUpperCase() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension StringExtension on String? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  String getUsername() {
    return isNullOrEmpty() ? "" : "@$this";
  }

  String appendRootUrl() {
    return this == null ? placeHolderImageUrl : "${DioClient.baseUrl}image/download/$this";
  }

  String mkFirstLetterUpperCase() {
    if (isNullOrEmpty()) return "";
    return this![0].toUpperCase() + this!.substring(1);
  }

}

extension DoubleExtension on double {
  double roundToDecimal() {
    return double.tryParse(toStringAsFixed(2)) ?? 0.0;
  }
}

extension ListExtension on List? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  String? getFirst<T>() {
    return !isNullOrEmpty() ? this![0] : null;
  }
}

extension BaseCallbackExt on Response {
  parse<T extends Serializable>(Function(BaseCallback<T>) callback) async {
    $logger.printObj(this);
    if (data != null) {
      var response = BaseResponse<T>.fromJson(data);
      if (response.status == true) {
        callback(BaseCallback<T>(
            success: true, data: response.data, message: response.message));
      } else {
        callback(BaseCallback<T>(
            success: false,
            isFieldError: response.message.isNullOrEmpty(),
            message: !response.message.isNullOrEmpty()
                ? response.message
                : getErrorMessage(response.code)));
      }
    } else {
      callback(BaseCallback<T>(
          success: false, message: getErrorMessage(statusCode)));
    }
  }

  parseDynamic(Function(BaseCallback<dynamic>) callback) async {
    print(this);
    if (data != null) {
      var response = RootResponse.fromJson(data);
      if (response.status == true) {
        callback(BaseCallback(success: true, message: response.message));
      } else {
        callback(BaseCallback(
            success: false,
            isFieldError: response.message.isNullOrEmpty(),
            message: !response.message.isNullOrEmpty()
                ? response.message
                : getErrorMessage(response.code)));
      }
    } else {
      callback(
          BaseCallback(success: false, message: getErrorMessage(statusCode)));
    }
  }

  parseString(Function(BaseCallback<String>) callback) async {
    if (data != null) {
      var response = BaseStringResponse.fromJson(data);
      if (response.success == true) {
        callback(BaseCallback<String>(
            success: true, data: response.data, message: response.message));
      } else {
        callback(BaseCallback<String>(
            success: false,
            isFieldError: response.message.isNullOrEmpty(),
            message: !response.message.isNullOrEmpty()
                ? response.message
                : getErrorMessage(response.code)));
      }
    } else {
      callback(BaseCallback<String>(
          success: false, message: getErrorMessage(statusCode)));
    }
  }

  parseList<T extends Serializable>(
      Function(BaseListCallback<T>) callback) async {
    // $logger.printObj(this);
    if (data != null) {
      var response = ListBaseResponse<T>.fromJson(data);
      $logger.log(
          message:
              "DEVENDRA  ${response.status} ${response.data?.map((e) => e.toJson())}");
      if (response.status == true) {
        callback(BaseListCallback<T>(
            success: true,
            canGiveReview: response.canGiveReview,
            data: response.data,
            message: response.message));
      } else {
        callback(BaseListCallback<T>(
            success: false,
            isFieldError: response.message.isNullOrEmpty(),
            message: !response.message.isNullOrEmpty()
                ? response.message
                : getErrorMessage(response.code)));
      }
    } else {
      callback(BaseListCallback<T>(
          success: false, message: getErrorMessage(statusCode)));
    }
  }
}

extension OTPPinExt on OtpPinFieldState {
  String getPin() {
    String pin = "";
    for (var text in pinsInputed) {
      pin += text;
    }
    return pin;
  }
}
