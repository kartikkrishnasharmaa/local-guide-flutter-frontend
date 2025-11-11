import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/admin/dashboard/admin_dashboard.dart';
import 'package:localguider/ui/authentication/login.dart';
import 'package:localguider/ui/dashboard/dashboard.dart';
import 'package:localguider/ui/home/home.dart';
import 'package:localguider/ui/settings/blocked.dart';
import 'package:localguider/utils/app_utils.dart';
import 'package:localguider/utils/file_utils.dart';
import 'package:localguider/utils/logger.dart';
import 'package:localguider/utils/share_pref.dart';
import 'package:localguider/utils/user.dart';
import 'package:localguider/values/strings.dart';
import 'blocs/auth_bloc.dart';
import 'db/objectbox.dart';
import 'firebase_options.dart';
import 'models/requests/update_user_request_dto.dart';
import 'network/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await $sharedPrefs.init();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _whenUnAuth();
    updateFcmToken();
    if($appUtils.isNotificationOn()) {
      $appUtils.subscribeToTopics();
    }
    return GetMaterialApp(
      title: $strings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: $user.getUser()?.isBlocked == true ? const Blocked() : (($user.isVerified()
          ? ($isAdmin
              ? const AdminDashboard()
              : ($user.getUser()?.photographer == true || $user.getUser()?.guider == true)
                  ? const Dashboard()
                  : const Home())
          : const Login())),
    );
  }

  _whenUnAuth() {
    logOutStream.stream.listen((logOut) async {
      if (logOut) {
        await $user.logOut();
        navigate(const Login(), finishAffinity: true);
        logOutStream.add(false);
      }
    });
    if(!$user.isVerified()) {
      HomeBloc().getSettings(
          isShowLoading: false,
          uId: null,
          pId: null,
          gId: null,
          callback: (p0) {
            if (p0.success == true && p0.data != null) {
              $appUtils.saveSettings(p0.data!);
            }
          });
    }
  }

}

updateFcmToken() {
  if(!kIsWeb && $user.isVerified()) {
    FirebaseMessaging.instance.getToken().then((value) {
      $logger.log(message: "FirebaseMessaging.instance.getToken().then((value => $value ))}");
      if (value != null) {
        AuthBloc().updateUser(request: UpdateUserRequestDto(
            userId:  $user.getUser()?.id.toString(), fcm: value), disableLoading: true, callback: (p0) {});
      }
    }, onError: (err) {
      $logger.log(message: "FirebaseMessaging.instance.getToken() onError $err ))}");
    });
  }
}

navigate(Widget page,
    {bool unFocus = true,
    bool noAnim = false,
    bool finish = false,
    bool finishAffinity = false}) {
  if (unFocus) hideKeyboard();
  (finish ? Get.off : (finishAffinity ? Get.offAll : Get.to))(page,
      transition: noAnim ? null : Transition.fadeIn);
}

navigatePop(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

showKeyboard() {
  FocusManager.instance.primaryFocus?.requestFocus();
}

snackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 2),
  );
}

ObjectBox get $objectBox => ObjectBox();

AppStyle get $styles => AppStyle();

Dio get $apiClient => DioClient.dio;

User get $user => User();

Strings get $strings => Strings();

Logger get $logger => Logger();

AppUtils get $appUtils => AppUtils();

FileUtils get $fileUtils => FileUtils();

bool get $isAdmin => true;
