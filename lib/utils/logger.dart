import 'package:flutter/foundation.dart';

class Logger {
  log({String? key, required String message}) {
    if (kDebugMode) {
      print("${key ?? "DEVENDRA"} ----> $message");
    }
  }
  error({String? key, required String message}) {
    if (kDebugMode) print("${key ?? "DEVENDRA"} ERROR ----> $message");
  }
  printObj(object) {
    if(kDebugMode) print(object as dynamic);
  }
}
