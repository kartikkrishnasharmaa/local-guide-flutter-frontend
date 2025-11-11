class BaseStringResponse {
  final bool? success;
  final int? code;
  final String? data;
  final String? message;

  BaseStringResponse(
      {required this.success,
      required this.code,
      required this.data,
      required this.message});

  factory BaseStringResponse.fromJson(Map<String, dynamic> json) {
    return BaseStringResponse(
        success: json['status'] ?? false,
        code: json['code'] ?? 200,
        data: json['data'] ?? '',
        message: json['message'] ?? '');
  }
}
