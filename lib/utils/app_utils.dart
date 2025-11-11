import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:localguider/models/response/settings_model.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/utils/share_pref.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_libs.dart';
import '../components/custom_text.dart';

import '../main.dart';
import '../responsive.dart';
import '../ui/authentication/login.dart';

class AppUtils {
  double defaultCornerRadius = 12;

  double calculatePercentageOf(double x, double y) {
    return (x / 100) * y;
  }

  snackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: CustomText(text, color: $styles.colors.white,)));
  }

  saveSettings(SettingsModel settings) {
    $sharedPrefs.setString($strings.SETTINGS, json.encode(settings.toJson()));
  }

  SettingsModel? getSettings() {
    String? settings = $sharedPrefs.getString($strings.SETTINGS);
    if (settings.isNullOrEmpty()) return null;
    return SettingsModel.fromJson(json.decode(settings!));
  }

  bool dashboardHaveNotification() {
    return getSettings()?.unreadNotificationsGuider != null && getSettings()?.unreadNotificationsPhotographer != null && getSettings()?.unreadNotificationsGuider?.toInt() != 0 && getSettings()?.unreadNotificationsPhotographer?.toInt() != 0;
  }

  bool userHaveNotification() {
    return getSettings()?.unreadNotificationsUser != null && getSettings()?.unreadNotificationsUser?.toInt() != 0;
  }

  bool isNotificationOn() {
    return $sharedPrefs.getBool($strings.notification,) ?? true;
  }

  setNotificationOn(bool value) {
    $sharedPrefs.setBool($strings.notification, value);
    if(value) {
      subscribeToTopics();
    } else {
      _unsubscribeToTopics();
    }
  }

  subscribeToTopics() {
    if(!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic("all");
      if ($user.getUser()?.pid != null) {
        FirebaseMessaging.instance.subscribeToTopic("photographers");
      } else if ($user.getUser()?.gid != null) {
        FirebaseMessaging.instance.subscribeToTopic("guiders");
      } else {
        FirebaseMessaging.instance.subscribeToTopic("visitors");
      }
    }
  }

  _unsubscribeToTopics() {
    if (!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic("all");
      FirebaseMessaging.instance.subscribeToTopic("photographers");
      FirebaseMessaging.instance.subscribeToTopic("guiders");
      FirebaseMessaging.instance.subscribeToTopic("visitors");
    }
  }

  logOut(context) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: "Log Out?",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc: "Are you sure you want to log out?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
              $user.logOut().then((value) {
                navigate(const Login(), finishAffinity: true);
              });
            },
            btnCancelOnPress: () {})
        .show();
  }

  Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void share({text}) {
    Share.share(text ?? getSettings()?.shareSnippet ?? "");
  }

  void copyToClipBoard(String? text, BuildContext context) async {
    if(text == null) return;
    snackBar("Copied To Clipboard!", context);
    await Clipboard.setData(ClipboardData(text: text));
  }

  void shareToWhatsapp(String? text) {
    if(text == null) return;
    var url = 'https://wa.me/?text=${Uri.encodeComponent(text)}';
    openUrl(url);
  }

}

String placeHolderImageUrl =
    "https://localguider.online/logo/logo.png";
