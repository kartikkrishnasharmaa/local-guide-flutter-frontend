import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../blocs/home_bloc.dart';
import '../main.dart';

class DioClient {
  static final Dio _dio = Dio(
      BaseOptions(validateStatus: (statusCode) {
    if (statusCode == null) {
      return false;
    }
    if (statusCode == 422 || statusCode == 401) {
      if (statusCode == 401) {
        logOutStream.add(true);
      }
      return true;
    } else {
      return statusCode >= 200 && statusCode < 300;
    }
  }));


  static const String baseUrl =
      // 'https://localguider.online/api/';
      'http://31.97.227.108:8081/api/';

  // static const String mapBaseUrl = kIsWeb ?
  //     'https://maps.googleapis.com/maps/api/' : "https://maps.googleapis.com/maps/api/";

  static Dio get dio {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout =
        const Duration(minutes: 1); // You can adjust the timeout value
    _dio.options.receiveTimeout = const Duration(minutes: 1);

    setupInterceptors();

    return _dio;
  }

  // static Dio get mapDioClient {
  //   _dio.options.baseUrl = mapBaseUrl;
  //   _dio.options.connectTimeout =
  //       const Duration(minutes: 5); // You can adjust the timeout value
  //   _dio.options.receiveTimeout = const Duration(minutes: 5);
  //
  //   setupInterceptors(isMap: kIsWeb);
  //
  //   return _dio;
  // }

  static void setupInterceptors() {
    _dio.interceptors
        .add(LogInterceptor(requestHeader: true, requestBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if($user.isVerified()) {
          options.headers[$strings.AUTHORIZATION] = "${$strings.BEARER} ${$user.getToken()}";
          if(kDebugMode) {
            print("Token  ${$user.getToken()}");
          }
          $logger.printObj(options.data);
        }
        return handler.next(options);
      },
    ));
  }

}
