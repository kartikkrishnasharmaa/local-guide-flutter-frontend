import 'dart:io';

import 'package:dio/dio.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/requests/create_appointment_dto.dart';
import 'package:localguider/models/response/home_response_dto.dart';
import 'package:localguider/models/response/image_dto.dart';
import 'package:localguider/models/response/notification_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/review_dto.dart';
import 'package:localguider/models/response/service_dto.dart';
import 'package:localguider/models/response/withdrawal_model.dart';
import 'package:localguider/utils/extensions.dart';

import '../../base/base_callback.dart';
import '../../main.dart';
import '../../models/response/appointment_response.dart';
import '../../models/response/settings_model.dart';
import '../../models/response/transaction_dto.dart';
import '../../models/response/user_data.dart';
import '../../user_role.dart';
import '../network_const.dart';

var isStepUpdateInProgress = false;

class HomeRepository {
  static getHomeDetails(
      userId, Function(BaseCallback<HomeResponseDto>) callback) async {
    var formData = FormData.fromMap({"userId": userId});
    await $apiClient.post(EndPoints.HOME_DETAILS, data: formData).then((value) {
      value.parse<HomeResponseDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<HomeResponseDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<HomeResponseDto>(
          success: false, message: error.toString()));
    });
  }

  static getImagesById(photographerId, guiderId, placeId, page,
      Function(BaseListCallback<ImageDto>) callback) async {
    var formData = FormData.fromMap({
      "photographerId": photographerId,
      "guiderId": guiderId,
      "placeId": placeId,
      "page": page
    });
    await $apiClient.post(EndPoints.ALL_IMAGES_BY_ID, data: formData).then(
        (value) {
      value.parseList<ImageDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(
          BaseListCallback<ImageDto>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<ImageDto>(
          success: false, message: error.toString()));
    });
  }

  static addImage(image, title, photographerId, guiderId, placeId,
      Function(BaseCallback<String>) callback) async {
    var formData = FormData.fromMap({
      "image": image,
      "title": title,
      "photographerId": photographerId,
      "guiderId": guiderId,
      "placeId": placeId
    });
    await $apiClient.post(EndPoints.ADD_IMAGE, data: formData).then((value) {
      value.parseString((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<String>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<String>(success: false, message: error.toString()));
    });
  }

  static deleteImage(imageId, Function(BaseCallback<String>) callback) async {
    var formData = FormData.fromMap({"imageId": imageId});
    await $apiClient.post(EndPoints.DELETE_IMAGE, data: formData).then((value) {
      value.parseString((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<String>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<String>(success: false, message: error.toString()));
    });
  }

  static getReviewsById(userId, photographerId, guiderId, placeId,
      Function(BaseListCallback<ReviewDto>) callback) async {
    var formData = FormData.fromMap({
      "userId": userId,
      "photographerId": photographerId,
      "guiderId": guiderId,
      "placeId": placeId
    });
    await $apiClient.post(EndPoints.ALL_REVIEWS_BY_ID, data: formData).then(
        (value) {
      $logger.log(message: ">>>>>>>>>>>>>>>>  $value");
      value.parseList<ReviewDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(
          BaseListCallback<ReviewDto>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<ReviewDto>(
          success: false, message: error.toString()));
    });
  }

  static addReview(photographerId, guiderId, placeId, userId, rating, message,
      Function(BaseCallback<ReviewDto>) callback) async {
    var formData = FormData.fromMap({
      "photographerId": photographerId,
      "guiderId": guiderId,
      "placeId": placeId,
      "userId": userId,
      "rating": rating,
      "message": message
    });
    await $apiClient.post(EndPoints.ADD_REVIEW, data: formData).then((value) {
      value.parse<ReviewDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(
          BaseCallback<ReviewDto>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(
          BaseCallback<ReviewDto>(success: false, message: error.toString()));
    });
  }

  static getPhotographersByPlace(
      placeId, Function(BaseListCallback<PhotographerDto>) callback) async {
    var formData = FormData.fromMap({"placeId": placeId});
    await $apiClient
        .post(EndPoints.GET_PHOTOGRAPHERS_BY_PLACE_ID, data: formData)
        .then((value) {
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

  static getGuidersByPlace(
      placeId, Function(BaseListCallback<PhotographerDto>) callback) async {
    var formData = FormData.fromMap({"placeId": placeId});
    await $apiClient
        .post(EndPoints.GET_GUIDERS_BY_PLACE_ID, data: formData)
        .then((value) {
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

  static getProfile(
      String? userId, Function(BaseCallback<UserData>) callback) async {
    await $apiClient
        .post(EndPoints.GET_PROFILE, data: FormData.fromMap({"userId": userId}))
        .then((value) {
      value.parse<UserData>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<UserData>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(
          BaseCallback<UserData>(success: false, message: error.toString()));
    });
  }

  static getServices(photographerId, guiderId,
      Function(BaseListCallback<ServiceDto>) callback) async {
    await $apiClient
        .post(EndPoints.GET_SERVICES,
            data: FormData.fromMap(
                {"photographerId": photographerId, "guiderId": guiderId}))
        .then((value) {
      value.parseList<ServiceDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<ServiceDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<ServiceDto>(
          success: false, message: error.toString()));
    });
  }

  static deleteServices(
      serviceId, Function(BaseCallback<dynamic>) callback) async {
    await $apiClient
        .post(EndPoints.DELETE_SERVICES,
            data: FormData.fromMap({
              "serviceId": serviceId,
            }))
        .then((value) {
      value.parseDynamic((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<dynamic>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(
          BaseCallback<dynamic>(success: false, message: error.toString()));
    });
  }

  static saveServices(
      {String? photographerId,
      String? guiderId,
      String? serviceId,
      String? title,
      String? description,
      double? servicePrice,
      MultipartFile? image,
      Function(BaseCallback<ServiceDto>)? callback}) async {
    var formData = FormData.fromMap({
      if (photographerId != null) "photographerId": photographerId,
      if (guiderId != null) "guiderId": guiderId,
      "serviceId": serviceId,
      "title": title,
      "description": description,
      "servicePrice": servicePrice,
      if (image != null) "image": image
    });

    await $apiClient
        .post(
            serviceId != null
                ? EndPoints.UPDATE_SERVICES
                : EndPoints.SAVE_SERVICES,
            data: formData)
        .then((value) {
      value.parse<ServiceDto>((response) {
        callback!(response);
      });
    }, onError: (err) {
      callback!(
          BaseCallback<ServiceDto>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback!(
          BaseCallback<ServiceDto>(success: false, message: error.toString()));
    });
  }

  static getPlaces(lat, lng, page, searchText, onlyTopPlaces,
      Function(BaseListCallback<PlaceModel>) callback) async {
    await $apiClient
        .post(EndPoints.GET_PLACES_LIST,
            data: FormData.fromMap({
              "latitude": lat,
              "longitude": lng,
              "page": page,
              "topPlaces": onlyTopPlaces,
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

  static getPlacesByIds(
      String ids, Function(BaseListCallback<PlaceModel>) callback) async {
    await $apiClient
        .post(EndPoints.GET_PLACES_BY_IDS_LIST,
            data: FormData.fromMap({"ids": ids}))
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

  static addPlace(
      {placeName,
      MultipartFile? featuredImage,
      description,
      state,
      String? mapUrl,
      String? city,
      topPlace,
      String? address,
      lat,
      lng,
      Function(BaseCallback<PlaceModel>)? callback}) async {
    $logger.log(message: "message>>>>>>>>  MultipartFile? ${featuredImage}");
    var map = {
      "placeName": placeName,
      "featuredImage": featuredImage,
      "description": description,
      "state": state,
      "city": city,
      "topPlace": topPlace,
      "address": city,
      "mapUrl": mapUrl,
      "latitude": lat,
      "longitude": lng,
    };
    $logger.log(message: "message>>>>>>>>  ${map.toString()}}");
    await $apiClient
        .post(EndPoints.ADD_PLACE, data: FormData.fromMap(map))
        .then((value) {
      value.parse<PlaceModel>((response) {
        callback!(response);
      });
    }, onError: (err) {
      callback!(
          BaseCallback<PlaceModel>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback!(
          BaseCallback<PlaceModel>(success: false, message: error.toString()));
    });
  }

  static updatePlace(
      {placeName,
      placeId,
      MultipartFile? featuredImage,
      description,
      state,
      topPlace,
      String? mapUrl,
      String? city,
      String? address,
      lat,
      lng,
      Function(BaseCallback<PlaceModel>)? callback}) async {
    $logger.log(message: "message>>>>>>>>>>>>>  description? ${description}");
    var map = {
      "placeName": placeName,
      "placeId": placeId,
      "featuredImage": featuredImage,
      "description": description.toString(),
      "state": state,
      "city": city,
      "topPlace": topPlace,
      "address": city,
      "mapUrl": mapUrl,
      "latitude": lat,
      "longitude": lng,
    };
    $logger.log(message: "message>>>>>>>>  ${map.toString()}}");
    await $apiClient
        .post(EndPoints.UPDATE_PLACE, data: FormData.fromMap(map))
        .then((value) {
      value.parse<PlaceModel>((response) {
        callback!(response);
      });
    }, onError: (err) {
      callback!(
          BaseCallback<PlaceModel>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback!(
          BaseCallback<PlaceModel>(success: false, message: error.toString()));
    });
  }

  static getPhotographers(lat, lng, page, searchText,
      Function(BaseListCallback<PhotographerDto>) callback) async {
    await $apiClient
        .post(EndPoints.GET_PHOTOGRAPHERS,
            data: FormData.fromMap({
              "latitude": lat,
              "longitude": lng,
              "page": page,
              "searchText": searchText
            }))
        .then((value) {
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

  static getGuiders(lat, lng, page, searchText,
      Function(BaseListCallback<PhotographerDto>) callback) async {
    await $apiClient
        .post(EndPoints.GET_GUIDERS,
            data: FormData.fromMap({
              "latitude": lat,
              "longitude": lng,
              "page": page,
              "searchText": searchText
            }))
        .then((value) {
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

  static createAppointment(CreateAppointmentDto request,
      Function(BaseCallback<AppointmentResponse>) callback) async {
    await $apiClient
        .post(EndPoints.CREATE_APPOINTMENT, data: request.toJson())
        .then((value) {
      $logger.log(message: "${value.data}");
      value.parse<AppointmentResponse>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<AppointmentResponse>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<AppointmentResponse>(
          success: false, message: error.toString()));
    });
  }

  static getNotifications(userRole, id, page,
      Function(BaseListCallback<NotificationModel>) callback) async {
    var request = FormData.fromMap({
      if (userRole == UserRole.PHOTOGRAPHER) "photographerId": id,
      if (userRole == UserRole.GUIDER) "guiderId": id,
      if (userRole == UserRole.JUST_USER) "userId": id,
      if (userRole == UserRole.ADMIN) "admin": true,
      "page": page
    });
    await $apiClient.post(EndPoints.GET_NOTIFICATION, data: request).then(
        (value) {
      $logger.log(message: "${value.data}");
      value.parseList<NotificationModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<NotificationModel>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<NotificationModel>(
          success: false, message: error.toString()));
    });
  }

  static deleteNotification(
      id, Function(BaseCallback<dynamic>) callback) async {
    var map = {"notificationId": id};
    await $apiClient
        .post(EndPoints.DELETE_NOTIFICATION, data: FormData.fromMap(map))
        .then((value) {
      $logger.log(message: "${value.data}");
      value.parseDynamic((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<dynamic>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(
          BaseCallback<dynamic>(success: false, message: error.toString()));
    });
  }

  static markAsReadNotification(
      id, Function(BaseCallback<dynamic>) callback) async {
    var map = {"notificationId": id};
    await $apiClient
        .post(EndPoints.NOTIFICATION_MARK_AS_READ, data: FormData.fromMap(map))
        .then((value) {
      value.parseDynamic((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<dynamic>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(
          BaseCallback<dynamic>(success: false, message: error.toString()));
    });
  }

  static sendNotification(title, description, isAll, isPhotographers, isGuiders,
      isVisitors, Function(BaseCallback<NotificationModel>) callback) async {
    var map = {
      "fromAdmin": true,
      "forPhotographers": isPhotographers,
      "forGuiders": isGuiders,
      "forAll": isAll,
      "forUsers": isVisitors,
      "title": title,
      "description": description
    };
    await $apiClient.post(EndPoints.CREATE_NOTIFICATION, data: map).then(
        (value) {
      $logger.log(message: "${value.data}");
      value.parse<NotificationModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<NotificationModel>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<NotificationModel>(
          success: false, message: error.toString()));
    });
  }

  static photographerGuiderRequest(
      userId,
      UserRole userRole,
      MultipartFile featuredImage,
      String firmName,
      String email,
      String phone,
      String address,
      String placeId,
      String places,
      String description,
      List<ServiceDto> services,
      String idProofType,
      MultipartFile idProofFront,
      MultipartFile idProofBack,
      MultipartFile photograph,
      Function(BaseCallback<PhotographerDto>) callback) async {
    var map = {
      "userId": userId,
      "featuredImage": featuredImage,
      "firmName": firmName,
      "email": email,
      "phone": phone,
      "address": address,
      "placeId": placeId,
      "places": places,
      "description": description,
      "idProofType": idProofType,
      "idProofFront": idProofFront,
      "idProofBack": idProofBack,
      "photograph": photograph,
    };

    var index = 0;
    for (var element in services) {
      var multipartImage = element.image != null
          ? await HomeBloc.convertFileToMultipart(File(element.image!))
          : null;
      map["services[$index][title]"] = element.title;
      map["services[$index][description]"] = element.description;
      map["services[$index][servicePrice]"] = element.servicePrice;
      map["services[$index][multipartImage]"] = multipartImage;
      index++;
    }

    var formData = FormData.fromMap(map);

    await $apiClient
        .post(
            userRole == UserRole.GUIDER
                ? EndPoints.REQUEST_FOR_GUIDER
                : EndPoints.REQUEST_FOR_PHOTOGRAPHER,
            data: formData)
        .then((value) {
      $logger.log(message: "${value.data}");
      value.parse<PhotographerDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: error.toString()));
    });
  }

  static updatePhotographerGuiderDetails(
      int dtoId,
      UserRole userRole,
      String firmName,
      String email,
      String phone,
      String placeId,
      String places,
      String description,
      MultipartFile? featuredImage,
      Function(BaseCallback<PhotographerDto>) callback) async {
    FormData formData = FormData.fromMap({
      if (userRole == UserRole.PHOTOGRAPHER) "photographerId": dtoId,
      if (userRole == UserRole.GUIDER) "guiderId": dtoId,
      "firmName": firmName,
      "email": email,
      "phone": phone,
      "placeId": placeId,
      "places": places,
      "description": description,
      "featuredImage": featuredImage,
      "admin": false,
    });

    await $apiClient
        .post(
            userRole == UserRole.GUIDER
                ? EndPoints.UPDATE_GUIDER
                : EndPoints.UPDATE_PHOTOGRAPHER,
            data: formData)
        .then((value) {
      $logger.log(message: "${value.data}");
      value.parse<PhotographerDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: error.toString()));
    });
  }

  static getPhotographerOrGuiderDetails(UserRole userRole, id,
      Function(BaseCallback<PhotographerDto>) callback) async {
    var request = FormData.fromMap({
      if (userRole == UserRole.PHOTOGRAPHER) "photographerId": id,
      if (userRole == UserRole.GUIDER) "guiderId": id
    });
    await $apiClient
        .post(
            userRole == UserRole.PHOTOGRAPHER
                ? EndPoints.GET_PHOTOGRAPHER_DETAILS
                : EndPoints.GET_GUIDER_DETAILS,
            data: request)
        .then((value) {
      $logger.log(message: "${value.data}");
      value.parse<PhotographerDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: error.toString()));
    });
  }

  static getAppointmentList(
      UserRole userRole,
      String id,
      String? status,
      int page,
      String searchText,
      Function(BaseListCallback<AppointmentResponse>) callback) async {
    var request = FormData.fromMap({
      if (userRole == UserRole.PHOTOGRAPHER) "photographerId": id,
      if (userRole == UserRole.GUIDER) "guiderId": id,
      if (userRole == UserRole.JUST_USER) "userId": id,
      "page": page,
      "status": status,
      "searchText": searchText,
    });
    await $apiClient.post(EndPoints.GET_APPOINTMENT, data: request).then(
        (value) {
      $logger.log(message: "${value.data}");
      value.parseList<AppointmentResponse>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<AppointmentResponse>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<AppointmentResponse>(
          success: false, message: error.toString()));
    });
  }

  static respondAppointment(appointmentId, status, note,
      Function(BaseCallback<AppointmentResponse>) callback) async {
    await $apiClient
        .post(EndPoints.RESPOND_APPOINTMENT,
            data: FormData.fromMap({
              "status": status,
              "appointmentId": appointmentId,
              "note": note
            }))
        .then((value) {
      value.parse<AppointmentResponse>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<AppointmentResponse>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(
          BaseCallback<AppointmentResponse>(success: false, message: error.toString()));
    });
  }

  static getAppointmentByTransactionId(String transactionId,
      Function(BaseCallback<AppointmentResponse>) callback) async {
    await $apiClient
        .post(EndPoints.GET_APPOINTMENT_BY_TRANSACTION_ID,
            data: FormData.fromMap({
              "transactionId": transactionId,
            }))
        .then((value) {
      value.parse<AppointmentResponse>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<AppointmentResponse>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<AppointmentResponse>(
          success: false, message: error.toString()));
    });
  }

  static createTransaction(
      {userId,
      photographerId,
      guiderId,
      paymentToken,
      amount,
      required Function(BaseCallback<TransactionDto>) callback}) async {
    await $apiClient
        .post(EndPoints.CREATE_TRANSACTION,
            data: FormData.fromMap({
              "userId": userId,
              "photographerId": photographerId,
              "guiderId": guiderId,
              "paymentToken": paymentToken,
              "amount": amount
            }))
        .then((value) {
      value.parse<TransactionDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<TransactionDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<TransactionDto>(
          success: false, message: error.toString()));
    });
  }

  static updateTransaction(
      {paymentToken,
      paymentStatus,
      required Function(BaseCallback<TransactionDto>) callback}) async {
    await $apiClient
        .post(EndPoints.UPDATE_TRANSACTION,
            data: FormData.fromMap({
              "paymentToken": paymentToken,
              "paymentStatus": paymentStatus,
            }))
        .then((value) {
      value.parse<TransactionDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<TransactionDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<TransactionDto>(
          success: false, message: error.toString()));
    });
  }

  static transactionList(
      {userId,
      photographerId,
      guiderId,
      isAdmin,
      page,
      required Function(BaseListCallback<TransactionDto>) callback}) async {
    await $apiClient
        .post(EndPoints.TRANSACTION_LIST,
            data: FormData.fromMap({
              "userId": userId,
              "photographerId": photographerId,
              "guiderId": guiderId,
              "admin": isAdmin,
              "page": page,
            }))
        .then((value) {
      value.parseList<TransactionDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<TransactionDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<TransactionDto>(
          success: false, message: error.toString()));
    });
  }

  static makeWithdrawal(
      {photographerId,
      guiderId,
      amount,
      amountToBeSettled,
      charge,
      paymentToken,
      bankName,
      accountNumber,
      accountHolderName,
      ifsc,
      upiId,
      required Function(BaseCallback<WithdrawalModel>) callback}) async {
    await $apiClient
        .post(EndPoints.MAKE_WITHDRAWAL,
            data: FormData.fromMap({
              "photographerId": photographerId,
              "guiderId": guiderId,
              "amount": amount,
              "amountToBeSettled": amountToBeSettled,
              "charge": charge,
              "paymentToken": paymentToken,
              "bankName": bankName,
              "accountNumber": accountNumber,
              "accountHolderName": accountHolderName,
              "ifsc": ifsc,
              "upiId": upiId
            }))
        .then((value) {
      value.parse<WithdrawalModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<WithdrawalModel>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<WithdrawalModel>(
          success: false, message: error.toString()));
    });
  }

  static withdrawalList(
      {photographerId,
      guiderId,
      page,
      required Function(BaseListCallback<WithdrawalModel>) callback}) async {
    await $apiClient
        .post(EndPoints.GET_WITHDRAWAL,
            data: FormData.fromMap({
              "photographerId": photographerId,
              "guiderId": guiderId,
              "page": page,
            }))
        .then((value) {
      value.parseList<WithdrawalModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseListCallback<WithdrawalModel>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<WithdrawalModel>(
          success: false, message: error.toString()));
    });
  }

  static respondWithdrawal(
      {withdrawalId,
      status,
      note,
      required Function(BaseCallback<WithdrawalModel>) callback}) async {
    await $apiClient
        .post(EndPoints.RESPOND_WITHDRAWAL,
            data: FormData.fromMap(
                {"status": status, "withdrawalId": withdrawalId}))
        .then((value) {
      value.parse<WithdrawalModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<WithdrawalModel>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<WithdrawalModel>(
          success: false, message: error.toString()));
    });
  }

  static updateSettings(
      {required SettingsModel request,
      required Function(BaseCallback<SettingsModel>) callback}) async {
    await $apiClient
        .post(EndPoints.UPDATE_SETTINGS, data: request.toJson())
        .then((value) {
      value.parse<SettingsModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(
          BaseCallback<SettingsModel>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<SettingsModel>(
          success: false, message: error.toString()));
    });
  }

  static changeActiveStatus(
      {required bool status,
      int? gId,
      int? pId,
      required Function(BaseCallback<PhotographerDto>) callback}) async {
    await $apiClient
        .post(
            gId != null
                ? EndPoints.CHANGE_GUIDER_ACTIVE_STATUS
                : EndPoints.CHANGE_PHOTOGRAPHER_ACTIVE_STATUS,
            data: FormData.fromMap({
              "active": status,
              if (gId != null) "gId": gId,
              if (pId != null) "pId": pId
            }))
        .then((value) {
      value.parse<PhotographerDto>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<PhotographerDto>(
          success: false, message: error.toString()));
    });
  }

  static getSettings(
      {String? uId,
      String? pId,
      String? gId,
      required Function(BaseCallback<SettingsModel>) callback}) async {
    await $apiClient
        .post(EndPoints.GET_SETTINGS,
            data: FormData.fromMap({
              if (uId != null) "userId": uId,
              if (pId != null) "photographerId": pId,
              if (gId != null) "guiderId": gId
            }))
        .then((value) {
      value.parse<SettingsModel>((response) {
        callback(response);
      });
    }, onError: (err) {
      callback(
          BaseCallback<SettingsModel>(success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseCallback<SettingsModel>(
          success: false, message: error.toString()));
    });
  }
}
