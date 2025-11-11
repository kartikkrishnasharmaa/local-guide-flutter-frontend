
class RootResponse {

  final bool? status;
  final int? code;
  final String? message;

  RootResponse({
    required this.status,
    required this.code,
    required this.message,
  });

  factory RootResponse.fromJson(Map<String, dynamic> json) {
    return RootResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? ''
    );
  }

}


