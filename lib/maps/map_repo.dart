import 'package:dio/dio.dart';
import 'package:localguider/base/base_callback.dart';
import 'package:localguider/maps/LatLngResponse.dart';
import 'package:localguider/maps/places_response.dart';

import '../main.dart';
import '../network/network_const.dart';
import '../network/network_utils.dart';

class MapRepo {
  MapRepo._();

  static searchPlaces(
      String keyword, bool cities, Function(BaseListCallback<Predictions>) callback) async {
    var request = FormData.fromMap({
      "searchText": keyword,
      "cities": cities,
    });
    await $apiClient
        .post(EndPoints.GET_PLACES, data: request)
        .then((value) {
          print("<><><><><><><>>\n\n\n\n\n  $value");
      if (value.data != null) {
        var response = PlacesResponse.fromJson(value.data);
        if (response.status == "OK") {
          callback(BaseListCallback<Predictions>(
              success: true,
              data: response.predictions ?? [],
              message: "Places list fetched successfully"));
        } else {
          callback(BaseListCallback<Predictions>(
              success: false,
              message: "Something went wrong. Please try again later."));
        }
      } else {
        callback(BaseListCallback<Predictions>(
            success: false, message: getErrorMessage(value.statusCode)));
      }
    }, onError: (err) {
      callback(BaseListCallback<Predictions>(
          success: false, message: err.toString()));
    }).onError((error, stackTrace) {
      callback(BaseListCallback<Predictions>(
          success: false, message: error.toString()));
    });
  }

}
