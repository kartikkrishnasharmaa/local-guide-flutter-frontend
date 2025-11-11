import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/serializable.dart';

class HomeResponseDto extends Serializable {
  HomeResponseDto({
    this.places,
    this.guiders,
    this.photographers,
    this.privacyPolicy,
    this.termsAndConditions,
    this.contactUs,
    this.aboutUs,
    this.appLink,
  });

  HomeResponseDto.fromJson(dynamic json) {
    if (json['places'] != null) {
      places = [];
      json['places'].forEach((v) {
        places?.add(PlaceModel.fromJson(v));
      });
    }
    if (json['guiders'] != null) {
      guiders = [];
      json['guiders'].forEach((v) {
        guiders?.add(PhotographerDto.fromJson(v));
      });
    }
    if (json['photographers'] != null) {
      photographers = [];
      json['photographers'].forEach((v) {
        photographers?.add(PhotographerDto.fromJson(v));
      });
    }
    privacyPolicy = json['privacyPolicy'];
    termsAndConditions = json['termsAndConditions'];
    contactUs = json['contactUs'];
    aboutUs = json['aboutUs'];
    appLink = json['appLink'];
  }

  List<PlaceModel>? places;
  List<PhotographerDto>? guiders;
  List<PhotographerDto>? photographers;
  String? privacyPolicy;
  String? termsAndConditions;
  String? contactUs;
  String? aboutUs;
  dynamic appLink;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (places != null) {
      map['places'] = places?.map((v) => v.toJson()).toList();
    }
    if (guiders != null) {
      map['guiders'] = guiders?.map((v) => v.toJson()).toList();
    }
    if (photographers != null) {
      map['photographers'] = photographers?.map((v) => v.toJson()).toList();
    }
    map['privacyPolicy'] = privacyPolicy;
    map['termsAndConditions'] = termsAndConditions;
    map['contactUs'] = contactUs;
    map['aboutUs'] = aboutUs;
    map['appLink'] = appLink;
    return map;
  }
}
