import 'package:localguider/network/root_response.dart';

import '../main.dart';
import '../models/serializable.dart';
import 'object_parser.dart';

class ListBaseResponse<T extends Serializable> extends RootResponse {
  final List<T>? data;
  final bool? canGiveReview;

  ListBaseResponse(
      {required super.status,
      required super.code,
        this.canGiveReview,
      required this.data,
      required super.message});

  factory ListBaseResponse.fromJson(Map<String, dynamic> json) {
    List<T>? data;
    if (json['data'] != null) {
      data = <T>[];
      if (json["data"] != "{}") {
        try {
          json['data'].forEach((v) {
            var t = ObjectParser<T>().parseJson(v);
            if (t != null) data?.add(t);
          });
        } catch (e) {
          $logger.error(message: e.toString());
        }
      }
    }

    return ListBaseResponse<T>(
        status: json['status'],
        code: json['code'],
        canGiveReview: json['canGiveReview'],
        data: data,
        message: json['message']);
  }
}
