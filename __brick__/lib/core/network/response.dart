class ApiResponse<T> {
  ApiResponse({
    required this.status,
    required this.message,
    this.result,
    this.count,
  });

  Status status;
  String? message;
  T? result;
  int? count;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    status: Status.fromJson(json["status"]),
    message: json["message"],
    result: json["result"],
    count: json["count"],
  );

  factory ApiResponse.dioError({String message = ""}) => ApiResponse(
    status: Status(code: "-1", error: true),
    message: message,
  );
}

class Status {
  Status({this.code = "-1", this.error = false});

  String code;
  bool error;

  factory Status.fromJson(Map<String, dynamic> json) =>
      Status(code: json["code"].toString(), error: json["error"]);
}