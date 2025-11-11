import 'package:localguider/models/serializable.dart';

class SettingsModel extends Serializable {
  late int? id;
  late String? privacyPolicy;
  late String? termsAndConditions;
  late String? aboutUs;
  late String? email;
  late String? phoneNumber;
  late String? whatsAppNumber;
  late String? instagram;
  late String? facebook;
  late String? twitter;
  late String? razorpayAPIKey;
  late String? razorpaySecretKey;
  late String? shareSnippet;
  late double? minimumWithdrawal;
  late double? minimumAddBalance;
  late double? appointmentPlatformCharge;
  late double? withdrawalCharge;
  num? unreadNotificationsUser;
  num? unreadNotificationsPhotographer;
  num? unreadNotificationsGuider;

  SettingsModel();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'privacyPolicy': privacyPolicy,
      'termsAndConditions': termsAndConditions,
      'aboutUs': aboutUs,
      'email': email,
      'phoneNumber': phoneNumber,
      'whatsAppNumber': whatsAppNumber,
      'instagram': instagram,
      'facebook': facebook,
      'twitter': twitter,
      'shareSnippet': shareSnippet,
      'razorpayAPIKey': razorpayAPIKey,
      'razorpaySecretKey': razorpaySecretKey,
      'minimumWithdrawal': minimumWithdrawal,
      'minimumAddBalance': minimumAddBalance,
      'appointmentPlatformCharge': appointmentPlatformCharge,
      'withdrawalCharge': withdrawalCharge,
      'unreadNotificationsUser': unreadNotificationsUser,
      'unreadNotificationsPhotographer': unreadNotificationsPhotographer,
      'unreadNotificationsGuider': unreadNotificationsGuider,
    };
  }

  SettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    privacyPolicy = json['privacyPolicy'];
    termsAndConditions = json['termsAndConditions'];
    aboutUs = json['aboutUs'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    whatsAppNumber = json['whatsAppNumber'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    shareSnippet = json['shareSnippet'];
    razorpayAPIKey = json['razorpayAPIKey'];
    razorpaySecretKey = json['razorpaySecretKey'];
    minimumWithdrawal = json['minimumWithdrawal'];
    minimumAddBalance = json['minimumAddBalance'];
    appointmentPlatformCharge = json['appointmentPlatformCharge'];
    withdrawalCharge = json['withdrawalCharge'];
    unreadNotificationsUser = json['unreadNotificationsUser'];
    unreadNotificationsPhotographer = json['unreadNotificationsPhotographer'];
    unreadNotificationsGuider = json['unreadNotificationsGuider'];
  }
}