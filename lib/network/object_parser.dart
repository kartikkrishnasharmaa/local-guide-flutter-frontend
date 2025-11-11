import 'package:localguider/maps/LatLngResponse.dart';
import 'package:localguider/maps/places_response.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/admin_dashboard_dto.dart';
import 'package:localguider/models/response/image_dto.dart';
import 'package:localguider/models/response/service_dto.dart';
import 'package:localguider/models/response/sign_in_response.dart';

import '../models/response/appointment_response.dart';
import '../models/response/home_response_dto.dart';
import '../models/response/notification_model.dart';
import '../models/response/photographer_dto.dart';
import '../models/response/review_dto.dart';
import '../models/response/settings_model.dart';
import '../models/response/transaction_dto.dart';
import '../models/response/user_data.dart';
import '../models/response/withdrawal_model.dart';
import '../models/serializable.dart';

class ObjectParser<T extends Serializable> {
  T? parseJson(dynamic v) {
    var result;
    switch (T) {
      case UserData:
        result = UserData.fromJson(v);
        break;
      case PlacesResponse:
        result = PlacesResponse.fromJson(v);
        break;
      case SignInResponse:
        result = SignInResponse.fromJson(v);
        break;
      case LatLngResponse:
        result = LatLngResponse.fromJson(v);
        break;
      case HomeResponseDto:
        result = HomeResponseDto.fromJson(v);
      case ImageDto:
        result = ImageDto.fromJson(v);
        break;
      case PhotographerDto:
        result = PhotographerDto.fromJson(v);
        break;
      case ReviewDto:
        result = ReviewDto.fromJson(v);
        break;
      case ServiceDto:
        result = ServiceDto.fromJson(v);
        break;
      case AppointmentResponse:
        result = AppointmentResponse.fromJson(v);
        break;
      case PlaceModel:
        result = PlaceModel.fromJson(v);
        break;
      case TransactionDto:
        result = TransactionDto.fromJson(v);
        break;
      case WithdrawalModel:
        result = WithdrawalModel.fromJson(v);
        break;
      case SettingsModel:
        result = SettingsModel.fromJson(v);
        break;
      case AdminDashboardDto:
        result = AdminDashboardDto.fromJson(v);
        break;
      case NotificationModel:
        result = NotificationModel.fromJson(v);
        break;
      case NoParamObj:
        result = NoParamObj.fromJson(v);
        break;
    }
    return result;
  }
}
