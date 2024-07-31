class ResponseModel {
  ResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  dynamic data;

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
