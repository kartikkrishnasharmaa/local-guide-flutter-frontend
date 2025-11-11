
import 'package:localguider/network/root_response.dart';

import '../models/serializable.dart';
import 'object_parser.dart';

class BaseResponse<T extends Serializable> extends RootResponse {
  final T? data;

  BaseResponse({
    required this.data,
    required super.status,
    required super.code,
    required super.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse<T>(
      status: json['status'] ?? false,
      code: json['code'] ?? 200,
      data: json['data'] != null ? ObjectParser<T>().parseJson(json['data']) : null,
      message: json['message'] ?? ''
    );
  }
}
