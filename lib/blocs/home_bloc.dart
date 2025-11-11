import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/requests/create_appointment_dto.dart';
import 'package:localguider/models/response/appointment_response.dart';
import 'package:localguider/models/response/home_response_dto.dart';
import 'package:localguider/models/response/notification_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/review_dto.dart';
import 'package:localguider/models/response/service_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/models/response/withdrawal_model.dart';
import 'package:localguider/network/repository/home_repository.dart';
import 'package:localguider/user_role.dart';
import '../base/base_bloc.dart';
import '../base/base_callback.dart';
import '../common_libs.dart';
import '../maps/LatLngResponse.dart';
import '../models/response/image_dto.dart';
import '../models/response/settings_model.dart';
import '../models/response/transaction_dto.dart';

final StreamController<bool> logOutStream = StreamController<bool>.broadcast();

class HomeBloc extends BaseBloc {

  final StreamController<BaseCallback<HomeResponseDto>> homeDtoStream =
  StreamController<BaseCallback<HomeResponseDto>>.broadcast();

  final StreamController<BaseListCallback<ImageDto>?> imagesDtoStream =
  StreamController<BaseListCallback<ImageDto>?>.broadcast();

  final StreamController<BaseListCallback<ReviewDto>?> reviewsStream =
  StreamController<BaseListCallback<ReviewDto>?>.broadcast();

  final StreamController<BaseCallback<ReviewDto>?> addReviewStream =
  StreamController<BaseCallback<ReviewDto>?>.broadcast();

  final StreamController<BaseListCallback<PhotographerDto>?>
  photographersDtoStream =
  StreamController<BaseListCallback<PhotographerDto>?>.broadcast();

  final StreamController<BaseCallback<PhotographerDto>?>
  photographersDetailsStream =
  StreamController<BaseCallback<PhotographerDto>?>.broadcast();

  final StreamController<BaseCallback<UserData>?> profileStream =
  StreamController<BaseCallback<UserData>?>.broadcast();

  final StreamController<BaseListCallback<ServiceDto>?> servicesListStream =
  StreamController<BaseListCallback<ServiceDto>?>.broadcast();

  final StreamController<BaseCallback<AppointmentResponse>?>
  createAppointmentStream =
  StreamController<BaseCallback<AppointmentResponse>?>.broadcast();

  final StreamController<BaseListCallback<PlaceModel>?> placeListStream =
  StreamController<BaseListCallback<PlaceModel>?>.broadcast();

  final StreamController<BaseCallback<LatLngResponse>?> latLngResponseStream =
  StreamController<BaseCallback<LatLngResponse>?>.broadcast();

  void getHomeDetails(userId) {
    showLoading();
    HomeRepository.getHomeDetails(userId, (p0) {
      dismissLoading();
      homeDtoStream.add(p0);
    });
  }

  void getImages(photographerId, guiderId, placeId, page,
      Function(BaseListCallback<ImageDto>) callback) {
    showLoading();
    HomeRepository.getImagesById(photographerId, guiderId, placeId, page, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void addImage(Uint8List image, photographerId, guiderId, placeId,
      Function(BaseCallback<String>) callback) async {
    showLoading();
    HomeRepository.addImage(await convertUint8ListToMultipart(image), "",
        photographerId, guiderId, placeId, (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void deleteImage(imageId, Function(BaseCallback<String>) callback) async {
    showLoading();
    HomeRepository.deleteImage(imageId, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void getReviews(userId, photographerId, guiderId, placeId,
      Function(BaseListCallback<ReviewDto>)? callback) {
    showLoading();
    HomeRepository.getReviewsById(userId, photographerId, guiderId, placeId,
            (p0) {
          dismissLoading();
          if (callback != null) {
            callback(p0);
          } else {
            reviewsStream.add(p0);
          }
        });
  }

  void addReview(photographerId,
      guiderId,
      placeId,
      userId,
      rating,
      message,) {
    showLoading();
    HomeRepository.addReview(
        photographerId,
        guiderId,
        placeId,
        userId,
        rating,
        message, (p0) {
      dismissLoading();
      addReviewStream.add(p0);
    });
  }

  void getPhotographersByPlace(placeId,
      Function(BaseListCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.getPhotographersByPlace(placeId, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void getPhotographers(double lat, double lng, int page, String searchText,
      Function(BaseListCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.getPhotographers(lat, lng, page, searchText, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void getGuiders(double lat, double lng, int page, String searchText,
      Function(BaseListCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.getGuiders(lat, lng, page, searchText, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void getGuidersByPlace(placeId,
      Function(BaseListCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.getGuidersByPlace(placeId, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void getProfile(String userId,) {
    HomeRepository.getProfile(userId, (p0) {
      profileStream.add(p0);
    });
  }

  void getServices(photographerId, guiderId,
      Function(BaseListCallback<ServiceDto>)? callback) {
    showLoading();
    HomeRepository.getServices(photographerId, guiderId, (p0) {
      dismissLoading();
      if (callback != null) {
        callback.call(p0);
      } else {
        servicesListStream.add(p0);
      }
    });
  }

  void getPlacesByIds(String ids,
      Function(BaseListCallback<PlaceModel>) callback) {
    showLoading();
    HomeRepository.getPlacesByIds(ids, (p0) {
      dismissLoading();
      callback.call(p0);
    });
  }

  void deleteServices(serviceId, Function(BaseCallback<dynamic>) callback) {
    showLoading();
    HomeRepository.deleteServices(serviceId, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void saveService({String? photographerId,
    String? guiderId,
    String? serviceId,
    String? title,
    String? description,
    double? servicePrice,
    File? image,
    required Function(BaseCallback<ServiceDto>) callback}) async {
    showLoading();
    MultipartFile? multipartFile;
    if (image != null) {
      multipartFile = await MultipartFile.fromFile(image.path);
    }
    HomeRepository.saveServices(
        photographerId: photographerId,
        guiderId: guiderId,
        serviceId: serviceId,
        title: title,
        description: description,
        servicePrice: servicePrice,
        image: multipartFile,
        callback: (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void getPlaces(double lat, double lng, int page, String searchText,
      Function(BaseListCallback<PlaceModel>) callback,
      {onlyTopPlaces = false}) {
    showLoading();
    HomeRepository.getPlaces(lat, lng, page, searchText, onlyTopPlaces, (p0) {
      dismissLoading();
      callback(p0);
      $logger.log(message: "Test 2 <><>  ${p0.data?.length}");
    });
  }

  void addPlace({Uint8List? featuredImage,
    placeName,
    String? state,
    String? mapUrl,
    String? city,
    String? address,
    String? description,
    topPlace,
    double? lat,
    double? lng,
    required Function(BaseCallback<PlaceModel>) callback}) async {
    showLoading();
    MultipartFile? image = featuredImage != null
        ? await convertUint8ListToMultipart(featuredImage)
        : null;
    $logger.log(message: "message>>>>>>>>  MultipartFile? ${image}");
    HomeRepository.addPlace(
        featuredImage: image,
        placeName: placeName,
        city: city,
        address: address,
        mapUrl: mapUrl,
        topPlace: topPlace,
        description: description,
        state: state,
        lat: lat,
        lng: lng,
        callback: (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void updatePlace({Uint8List? featuredImage,
    placeName,
    placeId,
    String? mapUrl,
    String? city,
    String? address,
    topPlace,
    String? state,
    String? description,
    double? lat,
    double? lng,
    required Function(BaseCallback<PlaceModel>) callback}) async {
    showLoading();
    MultipartFile? image = featuredImage != null
        ? await convertUint8ListToMultipart(featuredImage)
        : null;
    $logger.log(message: "message>>>>>>>>  MultipartFile? ${image}");
    HomeRepository.updatePlace(
        placeId: placeId,
        featuredImage: image,
        placeName: placeName,
        description: description,
        state: state,
        city: city,
        topPlace: topPlace,
        mapUrl: mapUrl,
        address: address,
        lat: lat,
        lng: lng,
        callback: (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void createAppointment(CreateAppointmentDto request,) {
    $logger.log(message: request.toJson().toString());
    showLoading();
    HomeRepository.createAppointment(request, (p0) {
      dismissLoading();
      createAppointmentStream.add(p0);
    });
  }

  void applyForPhotographerOrGuider(userId,
      UserRole userRole,
      Uint8List featuredImage,
      String firmName,
      String email,
      String phone,
      String address,
      String placeId,
      String places,
      String description,
      List<ServiceDto> services,
      String idProofType,
      Uint8List idProofFront,
      Uint8List idProofBack,
      Uint8List photograph) async {
    showLoading();

    HomeRepository.photographerGuiderRequest(
        userId,
        userRole,
        await convertUint8ListToMultipart(featuredImage),
        firmName,
        email,
        phone,
        address,
        placeId,
        places,
        description,
        services,
        idProofType,
        await convertUint8ListToMultipart(idProofFront),
        await convertUint8ListToMultipart(idProofBack),
        await convertUint8ListToMultipart(photograph), (p0) {
      $logger.log(message: "message 1 ${p0.success}");
      dismissLoading();
      photographersDetailsStream.add(p0);
    });
  }

  void updatePhotographerOrGuider(int dtoId,
      UserRole userRole,
      String firmName,
      String email,
      String phone,
      String placeId,
      String places,
      String description,
      Uint8List? featuredImage,
      Function(BaseCallback<PhotographerDto>) callback) async {
    showLoading();
    HomeRepository.updatePhotographerGuiderDetails(
        dtoId,
        userRole,
        firmName,
        email,
        phone,
        placeId,
        places,
        description,
        featuredImage != null ? await convertUint8ListToMultipart(
            featuredImage) : null, (p0) {
      $logger.log(message: "message 1 ${p0.success}");
      dismissLoading();
      callback.call(p0);
    });
  }

  static Future<MultipartFile> convertFileToMultipart(File file) async {
    // Compress the image
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 20, // Set the quality of compression (0 to 100)
    );

    List<int>? compressedByteList = compressedBytes?.toList();
    if (compressedByteList == null) {
      return MultipartFile.fromFileSync(file.path);
    }
    File compressedImage = File('${file.path}_compressed.jpg');
    await compressedImage.writeAsBytes(compressedByteList);

    return MultipartFile.fromFile(
      compressedImage.path,
    );
  }

  static Future<MultipartFile> convertUint8ListToMultipart(
      Uint8List int8List) async {
    return MultipartFile.fromBytes(int8List,
        filename: "image_${DateTime
            .now()
            .microsecondsSinceEpoch}");
  }

  void getPhotographerDetails(UserRole userRole, String id,
      Function(BaseCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.getPhotographerOrGuiderDetails(userRole, id, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void getNotifications(UserRole userRole, String id, int page,
      Function(BaseListCallback<NotificationModel>) callback) {
    showLoading();
    HomeRepository.getNotifications(userRole, id, page, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void deleteNotification(String id,
      Function(BaseCallback<dynamic>) callback) =>
      HomeRepository.deleteNotification(id, callback);

  void markAsReadNotification(String id,
      Function(BaseCallback<dynamic>) callback) =>
      HomeRepository.markAsReadNotification(id, callback);

  void getAppointments(UserRole userRole,
      String id,
      String? status,
      int page,
      String searchText,
      Function(BaseListCallback<AppointmentResponse>) callback) {
    showLoading();
    HomeRepository.getAppointmentList(userRole, id, status, page, searchText,
            (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  respondAppointment(appointmentId, status, note,
      Function(BaseCallback<AppointmentResponse>) callback) {
    showLoading();
    HomeRepository.respondAppointment(appointmentId, status, note, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  getAppointmentByTransactionId(String transactionId,
      Function(BaseCallback<AppointmentResponse>) callback) {
    showLoading();
    HomeRepository.getAppointmentByTransactionId(transactionId, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  void createTransaction({userId,
    photographerId,
    guiderId,
    paymentToken,
    amount,
    required Function(BaseCallback<TransactionDto>) callback}) {
    showLoading();
    HomeRepository.createTransaction(
        userId: userId,
        photographerId: photographerId,
        guiderId: guiderId,
        paymentToken: paymentToken,
        amount: amount,
        callback: (p0) {
          callback(p0);
          dismissLoading();
        });
  }

  void updateTransaction({paymentToken,
    paymentStatus,
    required Function(BaseCallback<TransactionDto>) callback}) {
    showLoading();
    HomeRepository.updateTransaction(
        paymentToken: paymentToken,
        paymentStatus: paymentStatus,
        callback: (p0) {
          callback(p0);
          dismissLoading();
        });
  }

  void transactionList({userId,
    photographerId,
    guiderId,
    isAdmin,
    paymentStatus,
    page,
    required Function(BaseListCallback<TransactionDto>) callback}) {
    showLoading();
    HomeRepository.transactionList(
        userId: userId,
        photographerId: photographerId,
        guiderId: guiderId,
        isAdmin: isAdmin,
        page: page,
        callback: (p0) {
          callback(p0);
          dismissLoading();
        });
  }

  void makeWithdrawal({photographerId,
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
    required Function(BaseCallback<WithdrawalModel>) callback}) {
    showLoading();
    HomeRepository.makeWithdrawal(
        photographerId: photographerId,
        guiderId: guiderId,
        amount: amount,
        charge: charge,
        amountToBeSettled: amountToBeSettled,
        paymentToken: paymentToken,
        bankName: bankName,
        accountNumber: accountNumber,
        accountHolderName: accountHolderName,
        ifsc: ifsc,
        upiId: upiId,
        callback: (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void getWithdrawals({photographerId,
    guiderId,
    page,
    required Function(BaseListCallback<WithdrawalModel>) callback}) {
    showLoading();
    HomeRepository.withdrawalList(
        photographerId: photographerId,
        guiderId: guiderId,
        page: page,
        callback: (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void updateSettings({required SettingsModel request,
    required Function(BaseCallback<SettingsModel>) callback}) {
    showLoading();
    HomeRepository.updateSettings(
        request: request,
        callback: (p0) {
          dismissLoading();
          callback(p0);
        });
  }

  void getSettings({isShowLoading = true,
    String? uId,
    String? pId,
    String? gId,
    required Function(BaseCallback<SettingsModel>) callback}) {
    if (isShowLoading) {
      showLoading();
    }
    HomeRepository.getSettings(
        uId: uId,
        pId: pId,
        gId: gId,
        callback: (p0) {
          if (isShowLoading) {
            dismissLoading();
          }
          callback(p0);
        });
  }

  respondWithdrawal(withdrawalId, status, note,
      Function(BaseCallback<WithdrawalModel>) callback) {
    showLoading();
    HomeRepository.respondWithdrawal(
        withdrawalId: withdrawalId,
        status: status,
        note: note,
        callback: (p0) {
          callback(p0);
          dismissLoading();
        });
  }

  changeActiveStatus(bool status, int? gId, int? pId,
      Function(BaseCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.changeActiveStatus(
        status: status,
        gId: gId,
        pId: pId,
        callback: (p0) {
          callback(p0);
          dismissLoading();
        });
  }

  final otpResendDuration = 60;

  static String? _verificationId;
  static int? _resendToken;


  final StreamController<int?> resentTimeStream =
  StreamController<int?>.broadcast();


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
          Future.delayed(const Duration(seconds: 1), () {
            callback(BaseCallback(
                success: true,
                other: credential.smsCode,
                message: $strings.AUTO_FILL));
          });
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

}
