import 'package:dio/dio.dart';
import 'package:localguider/models/response/admin_dashboard_dto.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';

import '../../../base/base_callback.dart';
import '../../../main.dart';
import '../../../models/place_model.dart';
import '../../../network/network_const.dart';

class AdminRepository {

  static getPhotographers(UserRole userRole, int page, String status, String searchText,
      Function(BaseListCallback<PhotographerDto>) callback) async {
    FormData request = FormData.fromMap({
      "status": status,
      "page": page,
      "searchText": searchText,
    });
    $logger.log(message: request.toString());
    await $apiClient
        .post(
            userRole == UserRole.GUIDER
                ? EndPoints.GET_GUIDERS
                : EndPoints.GET_PHOTOGRAPHERS,
            data: request)
        .then((value) {
          $logger.log(message: "$value");
      value.parseList<PhotographerDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<PhotographerDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<PhotographerDto>(
          success: false, message: error.toString()));
    });
  }

  static getPlaces(page, searchText,
      Function(BaseListCallback<PlaceModel>) callback) async {
    await $apiClient
        .post(EndPoints.GET_PLACES_LIST,
        data: FormData.fromMap({
          "page": page,
          "searchText": searchText
        }))
        .then((value) {
      value.parseList<PlaceModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<PlaceModel>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<PlaceModel>(
          success: false, message: error.toString()));
    });
  }

  static adminDashboard(
      Function(BaseCallback<AdminDashboardDto>) callback) async {
    await $apiClient
        .get(EndPoints.ADMIN_DASHBOARD)
        .then((value) {
      value.parse<AdminDashboardDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<AdminDashboardDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<AdminDashboardDto>(
          success: false, message: error.toString()));
    });
  }

  static responsePhotographer(UserRole userRole, dtoId, status, reasonOfDecline,
      Function(BaseCallback<dynamic>) callback) async {
    await $apiClient
        .post(userRole == UserRole.GUIDER ? EndPoints.RESPOND_GUIDER : EndPoints.RESPOND_PHOTOGRAPHER,
        data: FormData.fromMap({
          "status": status,
          if(userRole == UserRole.GUIDER) "guiderId": dtoId,
          if(userRole == UserRole.PHOTOGRAPHER) "photographerId": dtoId,
          "reasonOfDecline": reasonOfDecline
        }))
        .then((value) {
      value.parseDynamic((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<dynamic>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<dynamic>(
          success: false, message: error.toString()));
    });
  }

  static getUsers(page, searchText,
      Function(BaseListCallback<UserData>) callback) async {
    await $apiClient
        .post(EndPoints.GET_USERS,
        data: FormData.fromMap({
          "page": page,
          "searchText": searchText
        }))
        .then((value) {
      value.parseList<UserData>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<UserData>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<UserData>(
          success: false, message: error.toString()));
    });
  }

   static deleteUser(userId,
      Function(BaseCallback<dynamic>) callback) async {
    await $apiClient
        .post(EndPoints.DELETE_USER,
        data: FormData.fromMap({
          "userId": userId,
        }))
        .then((value) {
      value.parseDynamic((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<dynamic>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<dynamic>(
          success: false, message: error.toString()));
    });
  }

  static deletePlace(placeId,
      Function(BaseCallback<dynamic>) callback) async {
    await $apiClient
        .post(EndPoints.DELETE_PLACE,
        data: FormData.fromMap({
          "placeId": placeId,
        }))
        .then((value) {
      value.parseDynamic((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<dynamic>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<dynamic>(
          success: false, message: error.toString()));
    });
  }

  static download(
      endPoint,
      Function(BaseCallback<String>) callback) async {
    await $apiClient
        .get(endPoint)
        .then((value) {
      value.parseString((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<String>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<String>(
          success: false, message: error.toString()));
    });
  }

}
